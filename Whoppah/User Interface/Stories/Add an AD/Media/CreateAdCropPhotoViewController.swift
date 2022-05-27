//
//  CreateAdCropPhotoViewController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 23/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class CreateAdCropPhotoViewController: UIViewController {
    var viewModel: CreateAdCropPhotoViewModel!
    private let bag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h1
        label.text = R.string.localizable.createAdCropPhotoTitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(red: 0.094, green: 0.106, blue: 0.118, alpha: 1)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var cropAreaView: CropAreaView = {
        let view = CropAreaView(frame: .zero)
        view.backgroundColor = UIColor(red: 0.094, green: 0.106, blue: 0.118, alpha: 0.7)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .smallText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.string.localizable.createAdCropPhotoDescription()
        return label
    }()

    private lazy var saveButton: PrimaryLargeButton = {
        let button = ViewFactory.createPrimaryButton(text: R.string.localizable.save_button_title())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        setupBindings()
        setupConstraints()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.isHidden = true
        cropAreaView.layer.mask = nil
        cropAreaView.layer.sublayers = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.isHidden = false
        setupZoomScale()
        setupCropAreaViewLayer()
    }
}

// MARK: - UIScrollViewDelegate

extension CreateAdCropPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Private

private extension CreateAdCropPhotoViewController {
    func setupNavBar() {
        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), transparent: false)
        addCloseButton(image: R.image.ic_close()).rx.tap.bind { [weak self] in
            self?.viewModel.close()
        }.disposed(by: bag)
    }

    func setupView() {
        analyticsKey = "AdCreation_Crop"
    }

    func setupBindings() {
        saveButton.rx.tap
            .map { [unowned self] in self.cropImage(self.imageView.image) }
            .bind(to: viewModel.inputs.save)
            .disposed(by: bag)

        viewModel.outputs.image
            .map { $0.image() }
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
    }

    func setupZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = max(widthScale, heightScale)
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(cropAreaView)
        view.addSubview(descriptionLabel)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            cropAreaView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cropAreaView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cropAreaView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cropAreaView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: saveButton.topAnchor, constant: -16),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        ])
    }
}

// MARK: - Crop Area

private extension CreateAdCropPhotoViewController {
    var cropAreaSize: CGSize {
        cropAreaView.frame.size
    }

    func cropImage(_ inputImage: UIImage?) -> UIImage? {
        let imageViewScale = 1 / scrollView.zoomScale
        let cropZone = CGRect(x: (scrollView.contentOffset.x + 25) * imageViewScale,
                              y: (scrollView.contentOffset.y + 25) * imageViewScale,
                              width: (cropAreaSize.width - 50) * imageViewScale,
                              height: (cropAreaSize.height - 50) * imageViewScale)

        guard let cutImageRef: CGImage = inputImage?.cgImage?.cropping(to: cropZone) else { return nil }
        return UIImage(cgImage: cutImageRef)
    }

    func setupCropAreaViewLayer() {
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: cropAreaSize))
        path.addRect(CGRect(x: 25, y: 25, width: cropAreaSize.width - 50, height: cropAreaSize.height - 50))

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd

        cropAreaView.layer.mask = maskLayer

        let line = CAShapeLayer()
        let roundedRect = CGRect(x: 24, y: 24, width: cropAreaSize.width - 48, height: cropAreaSize.width - 48)
        let linePath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 4)

        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = 3
        line.strokeColor = UIColor.white.cgColor

        cropAreaView.layer.sublayers = [line]
    }
}

class CropAreaView: UIView {
    override func point(inside _: CGPoint, with _: UIEvent?) -> Bool {
        false
    }
}
