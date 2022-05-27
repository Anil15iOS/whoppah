//
//  CameraSearchViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/1/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import HGCircularSlider
import OpalImagePicker
import Photos
import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class CameraSearchViewController: UIViewController {
    enum CameraPosition {
        case front
        case back
    }

    enum FlashMode {
        case on
        case off
    }

    enum AVFoundationError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }

    // MARK: - IBOutlets

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var topView: UIView!
    @IBOutlet var topViewHeight: NSLayoutConstraint!
    @IBOutlet var previewView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var cameraButton: PrimaryLargeButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var uploadProgressView: CircularSlider!
    @IBOutlet var stillCameraImageView: UIImageView!

    // MARK: - Properties

    private var captureSession: AVCaptureSession!
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var backCameraInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    private var cameraPosition: CameraPosition = .back
    private var categoryRepo: WhoppahCore.CategoryRepository!

    @Injected private var cacheService: CacheService
    @Injected private var recognitionService: RecognitionService
    @Injected private var searchService: SearchService
    @Injected private var eventTrackingService: EventTrackingService
    
    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopView()
        setUpBottomView()

        cameraButton.style = .primary
        cameraButton.makeCircular()
        categoryRepo = cacheService.categoryRepo!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Need to do when the view is in the hierarchy as it can display a dialog
        configureCameraController()
    }

    // MARK: - Private

    private func setUpTopView() {
        let window = UIApplication.shared.keyWindow!
        let topPadding = window.safeAreaInsets.top
        topViewHeight.constant = 60.0 + topPadding
    }

    private func toggleLoadingUI(_ visible: Bool) {
        uploadProgressView.isVisible = visible
        cameraButton.isVisible = !visible
        galleryButton.isVisible = !visible
        stillCameraImageView.isVisible = visible
        if visible {
            activityIndicatorView.startAnimating()
            uploadProgressView.endPointValue = 0.0
        } else {
            activityIndicatorView.stopAnimating()
            stillCameraImageView.image = nil
        }
    }

    private func setUpIntroView() {
        if !UserDefaultsConfig.hasShownSearchIntro {
            if let dialog = SearchIntroDialog.create() {
                present(dialog, animated: true) {
                    UserDefaultsConfig.hasShownSearchIntro = true
                }
            }
        }
    }

    private func setUpBottomView() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        ]

        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: bottomView.bounds.height)
        bottomView.layer.insertSublayer(gradient, at: 0)
    }

    private func showNoPermissionDialog() {
        let dialog = MissingPermissionDialog.create(forPermission: MissingPermissionType.camera)
        present(dialog, animated: true, completion: nil)
    }

    private func recogniseImage(_ image: UIImage?) {
        guard let image = image?.scaledToMaxWidth(600), let data = image.jpegData(compressionQuality: 0.8) else {
            DispatchQueue.main.async {
                self.toggleLoadingUI(false)
                self.showErrorDialog()
            }
            return
        }

        recognitionService.uploadImage(data: data)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .complete(recognition):
                    self.toggleLoadingUI(false)
                    self.dismiss(animated: true, completion: { [weak self] in
                        guard let url = URL(string: recognition.url), DeeplinkManager.shared.handleDeeplink(url: url) else { return }
                        self?.searchService.removeAllFilters()
                        DeeplinkManager.shared.executeDeeplink()
                    })
                case let .progress(obs):
                    obs
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] progress in
                            self?.uploadProgressView.endPointValue = CGFloat(progress.fraction)
                    }).disposed(by: self.bag)
                }
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    Navigator().navigate(route: Navigator.Route.search(input: .init()))
                }
            }).disposed(by: bag)
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        eventTrackingService.searchByPhoto.trackClickedClose()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func galleryAction(_: UIButton) {
        eventTrackingService.searchByPhoto.trackClickedGallery()
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 1
        imagePicker.allowedMediaTypes = [.image]
        imagePicker.imagePickerDelegate = self
        imagePicker.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { imagePicker.modalPresentationStyle = .fullScreen }
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func cameraAction(_: PrimaryLargeButton) {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            showNoPermissionDialog()
            return
        }

        eventTrackingService.searchByPhoto.trackClickedCamera()

        toggleLoadingUI(true)

        captureImage { image, error in
            if let error = error {
                self.showError(error)
                return
            }
            self.stillCameraImageView.image = image
            self.recogniseImage(image)
        }
    }
}

// MARK: - Camera Logic

extension CameraSearchViewController {
    func prepare(completionHandler: @escaping (Swift.Error?) -> Void) {
        DispatchQueue(label: "com.whoppah.prepare-camera").async {
            do {
                self.createCaptureSession()
                self.configureCaptureDevices()
                try self.configureDeviceInputs()
                try self.configureOutput()
            } catch {
                DispatchQueue.main.async { completionHandler(error) }
                return
            }
            DispatchQueue.main.async { completionHandler(nil) }
        }
    }

    func createCaptureSession() {
        captureSession = AVCaptureSession()
    }

    func configureCaptureDevices() {
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
    }

    func configureDeviceInputs() throws {
        guard let captureSession = captureSession else { throw AVFoundationError.captureSessionIsMissing }

        if let backCamera = backCamera {
            backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(backCameraInput!) {
                captureSession.addInput(backCameraInput!)
            }
        } else if let frontCamera = frontCamera {
            frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(frontCameraInput!) {
                captureSession.addInput(frontCameraInput!)
            }
        } else {
            throw AVFoundationError.noCamerasAvailable
        }
    }

    func configureOutput() throws {
        guard let captureSession = captureSession else { throw AVFoundationError.captureSessionIsMissing }
        photoOutput = AVCapturePhotoOutput()

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }

        captureSession.startRunning()
    }

    func displayPreview(on view: UIView) throws {
        guard let captureSession = captureSession, captureSession.isRunning else { throw AVFoundationError.captureSessionIsMissing }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = view.frame
    }

    private func configureCameraController() {
        guard captureSession == nil else { return }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            onCameraPermissionAcquired()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.onCameraPermissionAcquired()
                    } else {
                        self.showNoPermissionDialog()
                    }
                }
            }
        case .restricted, .denied:
            showNoPermissionDialog()
        default:
            break
        }
    }

    private func onCameraPermissionAcquired() {
        prepare { _ in
            try? self.displayPreview(on: self.previewView)
        }
        setUpIntroView()
    }

    func switchCameras() throws {
        guard let captureSession = captureSession, captureSession.isRunning else { throw AVFoundationError.captureSessionIsMissing }
        captureSession.beginConfiguration()
        switch cameraPosition {
        case .front:
            try switchToBackCamera()
        case .back:
            try switchToFrontCamera()
        }
        captureSession.commitConfiguration()
    }

    func switchToFrontCamera() throws {
        guard let backCameraInput = backCameraInput, captureSession.inputs.contains(backCameraInput),
            let frontCamera = frontCamera else { throw AVFoundationError.invalidOperation }

        frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        captureSession.removeInput(backCameraInput)

        if captureSession.canAddInput(frontCameraInput!) {
            captureSession.addInput(frontCameraInput!)
            cameraPosition = .front
        } else {
            throw AVFoundationError.invalidOperation
        }
    }

    func switchToBackCamera() throws {
        guard let frontCameraInput = frontCameraInput, captureSession.inputs.contains(frontCameraInput),
            let backCamera = backCamera else { throw AVFoundationError.invalidOperation }

        backCameraInput = try AVCaptureDeviceInput(device: backCamera)
        captureSession.removeInput(frontCameraInput)

        if captureSession.canAddInput(backCameraInput!) {
            captureSession.addInput(backCameraInput!)
            cameraPosition = .back
        } else {
            throw AVFoundationError.invalidOperation
        }
    }

    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            completion(nil, AVFoundationError.captureSessionIsMissing)
            return
        }

        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off // flashMode == .on ? .on : .off
        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletionBlock = completion
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraSearchViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error as NSError? {
            if let recovery = error.localizedRecoverySuggestion {
                showErrorDialog(message: "\(error.localizedDescription), \(recovery)")
            } else {
                showErrorDialog(message: "\(error.localizedDescription)")
            }
            photoCaptureCompletionBlock?(nil, error)
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: imageData)?.fixedOrientation()
        photoCaptureCompletionBlock?(image, error)
    }
}

// MARK: - OpalImagePickerControllerDelegate

extension CameraSearchViewController: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        picker.dismiss(animated: true, completion: nil)
        guard !assets.isEmpty else { return }
        let manager = PHImageManager()
        manager.fetchImages(assets: assets, imageFetched: nil) { images in
            guard let image = images.first else { return }
            self.toggleLoadingUI(true)
            self.stillCameraImageView.image = image
            self.recogniseImage(image)
        }
    }
}
