//
//  ProfileAvatarPickerViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 11/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import TLPhotoPicker
import Photos
import UIKit
import WhoppahCore

protocol ProfileAvatarPickerDelegate: AnyObject {
    func photoPicked(image: UIImage)
}

class ProfileAvatarPickerViewController: UIViewController {
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

    // MARK: Outlets

    @IBOutlet var previewView: UIView!
    @IBOutlet var flashButton: UIButton!

    // MARK: - Properties

    private var captureSession: AVCaptureSession!
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var backCameraInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    typealias PhotoCompletion = ((UIImage?, Error?) -> Void)
    private var photoCaptureCompletionBlock: PhotoCompletion?
    private var cameraPosition: CameraPosition = .back {
        didSet {
            let device = cameraPosition == .back ? backCamera : frontCamera
            flashButton.isVisible = device!.hasTorch
        }
    }

    private var flashMode: FlashMode = .off
    weak var delegate: ProfileAvatarPickerDelegate?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCameraController()
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        dismiss()
    }

    @IBAction func cameraAction(_: PrimaryLargeButton) {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            showNoPermissionDialog()
            return
        }

        captureImage { image, error in
            if let error = error {
                self.showError(error)
                return
            }
            guard let image = image else { return }
            DispatchQueue.main.async {
                let reviewVC: MediaReviewViewController = UIStoryboard.storyboard(storyboard: .addAnAD).instantiateViewController()
                reviewVC.delegate = self
                reviewVC.photo = AdPhoto.new(data: image)
                self.present(reviewVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func rotateAction(_: UIButton) {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            showNoPermissionDialog()
            return
        }

        do {
            try switchCameras()
        } catch {}
    }

    @IBAction func galleryAction(_: UIButton) {
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.mediaType = .image
        configure.maxSelectedAssets = 1
        
        let imagePicker = TLPhotosPickerViewController()
        imagePicker.configure = configure
        imagePicker.delegate = self

        imagePicker.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { imagePicker.modalPresentationStyle = .fullScreen }
        present(imagePicker, animated: true, completion: nil)
        
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == PHAuthorizationStatus.limited {
            imagePicker.presentAlert(title: "", message: R.string.localizable.photo_gallery_limited_access_message())
        }
    }

    @IBAction func flashAction(_: UIButton) {
        let image = flashMode == .on ? R.image.ic_flash_off() : R.image.ic_flashCamera()
        flashButton.setImage(image, for: .normal)
        flashMode = flashMode == .on ? .off : .on
    }

    // MARK: Private

    fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    private func showNoPermissionDialog() {
        let dialog = MissingPermissionDialog.create(forPermission: MissingPermissionType.camera)
        present(dialog, animated: true, completion: nil)
    }
}

// MARK: - Camera Logic

extension ProfileAvatarPickerViewController {
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

    func onCameraPermissionAcquired() {
        prepare { _ in
            try? self.displayPreview(on: self.previewView)
        }
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
        #if !targetEnvironment(simulator) // bug in xcode 12
        let cameraFlashMode: AVCaptureDevice.FlashMode = flashMode == .on ? .on : .off
        if photoOutput.supportedFlashModes.contains(cameraFlashMode) {
            settings.flashMode = cameraFlashMode
        }
        #endif
        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletionBlock = completion
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension ProfileAvatarPickerViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)?.fixedOrientation()
        photoCaptureCompletionBlock?(image, error)
    }
}

// MARK: - TLPhotosPickerViewControllerDelegate

extension ProfileAvatarPickerViewController: TLPhotosPickerViewControllerDelegate {
   
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
         guard !withPHAssets.isEmpty else { return }
         let manager = PHImageManager()
         manager.fetchImages(assets: withPHAssets, imageFetched: nil) { images in
            guard let image = images.first else { return }
            self.delegate?.photoPicked(image: image)
            self.dismiss()
         }
     }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        let alertController = UIAlertController(title: "",
                                                message: R.string.localizable.select_photos_max_exceeded("1"),
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: R.string.localizable.merchant_profile_incomplete_dialog_ok_button(),
                                   style: .cancel, handler: nil)
        alertController.addAction(action)
        picker.present(alertController, animated: true, completion: nil)
    }
}

// MARK: MediaReviewDelegate

extension ProfileAvatarPickerViewController: MediaReviewDelegate {
    func photoDeleted(_: AdPhoto, atPath _: IndexPath?) {
        // Nothing to do
    }

    func photoAccepted(_ photo: AdPhoto, atPath _: IndexPath?) {
        switch photo {
        case let .new(data):
            delegate?.photoPicked(image: data)
        default: break
        }
        dismiss()
    }

    func videoDeleted(_: AdVideo) {}
    func videoAccepted(_: AdVideo) {}
}
