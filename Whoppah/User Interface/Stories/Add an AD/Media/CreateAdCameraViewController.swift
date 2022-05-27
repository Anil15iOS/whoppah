//
//  CreateAdCameraViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/27/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import TLPhotoPicker
import Photos
import Resolver

class CreateAdCameraViewController: UIViewController {
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
    @IBOutlet var previewView: UIView!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var flashButton: UIButton!
    @IBOutlet var cameraButton: PrimaryLargeButton!
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var videoProgressBar: UIProgressView!
    @IBOutlet var cameraTipFirst: CameraViewTip!
    @IBOutlet var cameraTipSecond: CameraViewTip!

    // MARK: - Properties

    private var captureSession: AVCaptureSession!
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var backCameraInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput!
    private var videoOutput: AVCaptureMovieFileOutput?
    private var fileURL: URL?
    private var videoFilePath: URL?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    @Injected private var crashReporter: CrashReporter
    @Injected fileprivate var eventTrackingService: EventTrackingService
    @Injected fileprivate var adCreator: ADCreator

    var viewModel: CreateAdCameraViewModel!

    override var prefersStatusBarHidden: Bool { true }

    private var cameraPosition: CameraPosition = .back {
        didSet {
            let device = cameraPosition == .back ? backCamera : frontCamera
            flashButton.isVisible = device!.hasTorch
        }
    }

    private let bag = DisposeBag()
    private var flashMode: FlashMode = .off

    var videoTimer: Timer!
    var videoProgressCounter: Double = 0
    var videoProgressIncrement: Double = 0

    let shownTipsVideoFraming = "show_tips_recording"
    let tipDisplayDurationSecs = 4.0

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        setUpButtons()
        configureCameraController()
        setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        mediaCollectionView.reloadData()
    }

    // MARK: - Private

    private func setUpButtons() {
        cameraButton.backgroundColor = .orange
        cameraButton.makeCircular()
    }

    private func setUpCollectionView() {
        mediaCollectionView.delegate = self
        mediaCollectionView.register(UINib(nibName: MediaCell.nibName, bundle: nil), forCellWithReuseIdentifier: MediaCell.identifier)
        viewModel.outputs.mediaCells.bind(to: mediaCollectionView.rx.items(cellIdentifier: MediaCell.identifier, cellType: MediaCell.self)) { [weak self] _, viewModel, cell in
            guard let self = self else { return }
            cell.setUp(with: viewModel)
            cell.delegate = self
        }.disposed(by: bag)

        Observable.zip(mediaCollectionView.rx.itemSelected, mediaCollectionView.rx.modelSelected(MediaCellViewModel.self))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] path, model in
                guard let self = self else { return }
                self.viewModel.selectViewModel(atPath: path, videoFilePath: self.videoFilePath, viewModel: model)
            }).disposed(by: bag)
    }

    private func setupViewModel() {
        refreshModeUI()
        viewModel.outputs.cameraButtonEnabled.bind(to: cameraButton.rx.isEnabled).disposed(by: bag)
    }

    private func showNoPermissionDialog() {
        viewModel.coordinator.showNoPermissionDialog()
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        viewModel.dismiss()
    }

    @IBAction func galleryAction(_: UIButton) {
        viewModel.openGallery(delegate: self)
    }

    @IBAction func flashAction(_: UIButton) {
        if viewModel.mode == .video {
            let device = cameraPosition == .back ? backCamera : frontCamera
            if device?.hasTorch == true {
                do {
                    try device!.lockForConfiguration()
                    if flashMode == .on {
                        device!.torchMode = .on
                    } else {
                        device!.torchMode = .off
                    }
                    device!.unlockForConfiguration()
                } catch {}
            } else {
                return
            }
        }

        let image = flashMode == .on ? R.image.ic_flash_off() : R.image.ic_flashCamera()
        flashButton.setImage(image, for: .normal)
        flashMode = flashMode == .on ? .off : .on
    }

    @IBAction func nextButton(_: UIButton) {
        viewModel.next()
    }

    @IBAction func rotateAction(_: UIButton) {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            showNoPermissionDialog()
            return
        }
        do {
            try switchCameras()
        } catch {
            crashReporter.log(error: error)
        }
    }

    @IBAction func cameraAction(_: PrimaryLargeButton) {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            showNoPermissionDialog()
            return
        }

        if viewModel.mode == .video {
            if videoProgressCounter > Double.ulpOfOne {
                stopRecording()
            } else {
                startRecording()
            }
        } else {
            eventTrackingService.createAd.trackCapturePhotoClicked()
            captureImage { [weak self] image, error in
                if let error = error {
                    self?.showError(error)
                    self?.crashReporter.log(error: error)
                    return
                }

                guard let image = image else { return }
                self?.viewModel.addPhoto(AdPhoto.new(data: image))

                DispatchQueue.main.async { [weak self] in
                    self?.updateCameraTip()
                }
            }
        }
    }
}

// MARK: - Camera Logic

extension CreateAdCameraViewController {
    func prepare(completionHandler: @escaping (Swift.Error?) -> Void) {
        DispatchQueue(label: "com.whoppah.prepare-camera").async {
            do {
                try self.configureSession()
                try self.configureOutput()
            } catch {
                try? self.configureOutput()
                DispatchQueue.main.async { completionHandler(error) }
                return
            }

            DispatchQueue.main.async { completionHandler(nil) }
        }
    }

    func configureSession() throws {
        let session = AVCaptureSession()
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)

        if let backCamera = backCamera {
            backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            if session.canAddInput(backCameraInput!) {
                session.addInput(backCameraInput!)
            }
        } else if let frontCamera = frontCamera {
            frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            if session.canAddInput(frontCameraInput!) {
                session.addInput(frontCameraInput!)
            }
        } else {
            throw AVFoundationError.noCamerasAvailable
        }
        captureSession = session
    }

    func configureOutput() throws {
        #if targetEnvironment(simulator)
            let videoOutput = AVCaptureMovieFileOutput()
            videoOutput.maxRecordedDuration = CMTimeMake(value: Int64(ProductConfig.maxVideoDurationSeconds), timescale: 1)
            videoOutput.minFreeDiskSpaceLimit = 100 * 1024
            self.videoOutput = videoOutput
        #else
            guard let captureSession = captureSession else { throw AVFoundationError.captureSessionIsMissing }
            photoOutput = AVCapturePhotoOutput()

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }

            let videoOutput = AVCaptureMovieFileOutput()
            videoOutput.maxRecordedDuration = CMTimeMake(value: Int64(ProductConfig.maxVideoDurationSeconds), timescale: 1)
            videoOutput.minFreeDiskSpaceLimit = 100 * 1024
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            self.videoOutput = videoOutput

            captureSession.startRunning()
        #endif
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

    private func onCameraPermissionAcquired() {
        prepare { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.crashReporter.log(error: error)
            }
            try? self.displayPreview(on: self.previewView)
        }
        showTips()
    }

    private func refreshModeUI() {
        if viewModel.mode == .video {
            galleryButton.isHidden = true
            cameraButton.setImage(R.image.ic_video(), for: .normal)
        } else {
            galleryButton.isHidden = false
            cameraButton.setImage(R.image.camera_icon(), for: .normal)
        }
    }

    private func startRecording() {
        mediaCollectionView.reloadData()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = URL(string: "\(documentsURL.appendingPathComponent("temp"))" + ".mov")

        guard let fileURL = fileURL else { return }
        videoOutput?.startRecording(to: fileURL, recordingDelegate: self)

        cameraButton.setImage(R.image.camera_stop_icon(), for: .normal)

        if UserDefaults.standard.bool(forKey: shownTipsVideoFraming) == false {
            UserDefaults.standard.set(true, forKey: shownTipsVideoFraming)
            let text = R.string.localizable.create_ad_camera_tip_video_framing()
            cameraTipFirst.text = text
            cameraTipFirst.show()
            cameraTipSecond.hide()

            DispatchQueue.main.asyncAfter(deadline: .now() + tipDisplayDurationSecs) {
                if self.cameraTipFirst.text == text {
                    self.cameraTipFirst.hide()
                }
            }
        }

        if videoTimer == nil {
            videoProgressBar.layer.cornerRadius = 10
            videoProgressBar.progress = 0
            videoProgressBar.isVisible = true
            videoProgressBar.alpha = 0.0
            videoProgressIncrement = 0.1 / Double(ProductConfig.maxVideoDurationSeconds - 0.1)
            videoTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                self?.updateProgress()
            })
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.galleryButton.alpha = 0.0
                self.flashButton.alpha = 0.0
                self.mediaCollectionView.alpha = 0.0
                self.videoProgressBar.alpha = 1.0
            }
        }
    }

    private func stopRecording() {
        guard videoOutput?.isRecording == true else { return }
        videoOutput?.stopRecording()
        onRecordingStopped()
    }

    private func onRecordingStopped() {
        videoTimer.invalidate()
        videoTimer = nil
        videoProgressBar.isHidden = true
        videoProgressCounter = 0.0
        videoProgressIncrement = 0.0
        mediaCollectionView.isHidden = false
        mediaCollectionView.alpha = 0.0
        cameraButton.setImage(R.image.ic_video(), for: .normal)
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.galleryButton.alpha = 1.0
            self.flashButton.alpha = 1.0
            self.mediaCollectionView.alpha = 1.0
        }
    }

    @objc func updateProgress() {
        if videoProgressCounter >= 1.0 { stopRecording() }
        videoProgressBar.progress = Float(videoProgressCounter)
        videoProgressCounter += videoProgressIncrement
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

        guard !adCreator.mediaManager.hasMaxPhotos else {
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

    private func showTips() {
        switch viewModel.mode {
        case .photo:
            let tip1Text = R.string.localizable.create_ad_camera_tip_0()
            cameraTipFirst.text = tip1Text
            cameraTipFirst.show()

            DispatchQueue.main.asyncAfter(deadline: .now() + tipDisplayDurationSecs) {
                if self.cameraTipFirst.text == tip1Text {
                    self.cameraTipFirst.hide()
                }
            }
        case .video:
            break
        }
    }

    private func updateCameraTip() {
        guard let text = viewModel.cameraTip() else { return }
        cameraTipFirst.text = text
        cameraTipFirst.show()

        cameraTipSecond.hide()

        DispatchQueue.main.asyncAfter(deadline: .now() + tipDisplayDurationSecs) {
            if self.cameraTipFirst.text == text {
                self.cameraTipFirst.hide()
            }
        }
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension CreateAdCameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from _: [AVCaptureConnection], error: Error?) {
        if error != nil {
            let avError = error as? AVError
            if avError != nil, avError!.code == .maximumDurationReached || avError!.code == .maximumFileSizeReached {
                onRecordingStopped()
            } else {
                guard let error = error else {
                    return
                }

                crashReporter.log(error: error)
                showError(error)
            }
        }

        if output.recordedDuration.seconds < ProductConfig.minVideoDurationSeconds {
            viewModel.coordinator.showPoorMediaView(type: .video)
            return
        }

        let filemainurl = outputFileURL
        var thumbnailImage: UIImage?
        do {
            let asset = AVURLAsset(url: filemainurl as URL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            thumbnailImage = UIImage(cgImage: cgImage)
        } catch let error as NSError {
            crashReporter.log(error: error)
        }

        videoFilePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("mergeVideo\(arc4random() % 1000)d").appendingPathExtension("mp4")

        let tempfilemainurl = NSURL(string: videoFilePath!.absoluteString)!
        let sourceAsset = AVURLAsset(url: filemainurl as URL, options: nil)
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileType.mov
        assetExport.outputURL = tempfilemainurl as URL
        assetExport.exportAsynchronously { [weak self] in
            guard let self = self else { return }
            switch assetExport.status {
            case .completed:
                do {
                    self.adCreator.mediaManager.deleteVideo(forAd: self.adCreator.template?.id)
                    let data = try NSData(contentsOf: tempfilemainurl as URL, options: NSData.ReadingOptions()) as Data
                    let video = AdVideo.new(data: data, thumbnail: thumbnailImage, path: self.videoFilePath)
                    self.adCreator.mediaManager.addVideo(data: video)
                    DispatchQueue.main.async {
                        self.viewModel.next()
                    }
                } catch {
                    self.crashReporter.log(error: error)
                }
            case .failed:
                if let error = assetExport.error {
                    self.crashReporter.log(error: error)
                }
            case .cancelled:
                break
            default:
                break
            }
        }
    }

    func captureOutput(captureOutput _: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL _: NSURL!, fromConnections _: [AnyObject]!) {}
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CreateAdCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        defer {
            self.photoCaptureCompletionBlock = nil
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)?.fixedOrientation()
        photoCaptureCompletionBlock?(image, error)
    }
}

// MARK: - TLPhotosPickerViewControllerDelegate

extension CreateAdCameraViewController: TLPhotosPickerViewControllerDelegate {
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        let alertController = UIAlertController(title: "",
                                                message: R.string.localizable.select_photos_max_exceeded("\(adCreator.mediaManager.maxPhotoSelectionAllowed)"),
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: R.string.localizable.merchant_profile_incomplete_dialog_ok_button(),
                                   style: .cancel, handler: nil)
        alertController.addAction(action)
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        let manager = PHImageManager()
        
        manager.fetchImages(assets: withPHAssets, imageFetched: nil) { images in
            self.viewModel.onImagesPicked(images)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CreateAdCameraViewController: MediaCellDelegate {
    func cellDidPressCloseButton(_ cell: MediaCell) {
        let path = mediaCollectionView.indexPath(for: cell)!
        viewModel.deleteMedia(atPath: path)
    }
}

// MARK: - UICollectionViewDelegate

extension CreateAdCameraViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        viewModel.shouldSelectItem(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateAdCameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: 60.0, height: 60.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        16.0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        16.0
    }
}

// MARK: MediaReviewDelegate

extension CreateAdCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Scale down to reduce bandwidth
            let downsizedImage = image.scaledToMaxWidth(CGFloat(ProductConfig.maxImageLengthPixels))
            viewModel.addPhoto(AdPhoto.new(data: downsizedImage))
        }
        viewModel.next()
    }
}
