//
//  PriceAdviceViewController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 04/05/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class PriceAdviceViewController: UIViewController {
    var viewModel: PriceAdviceViewModel!
    private let bag = DisposeBag()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        ViewFactory.createTitle(R.string.localizable.priceSuggestionTitle())
    }()

    private lazy var descriptionLabel: UILabel = {
        ViewFactory.createLabel(text: R.string.localizable.priceSuggestionDescription(), lines: 2, font: .smallText)
    }()

    private lazy var credentialsLabel: UILabel = {
        ViewFactory.createTitle(R.string.localizable.priceSuggestionCredentialsTitle())
    }()

    private lazy var emailTextField: WPTextField = {
        ViewFactory.createEmail(placeholder: R.string.localizable.set_profile_personal_contact_email())
    }()

    private lazy var phoneNumberTextField: WPPhoneNumber = {
        ViewFactory.createPhoneNumber(placeholder: R.string.localizable.set_profile_personal_contact_phone())
    }()

    private lazy var descriptionTextView: WPTextViewContainer = {
        ViewFactory.createTextView(placeholder: R.string.localizable.priceSuggestionDescriptionPlaceholder())
    }()

    private lazy var bulletsView: (UILabel, UIView) = {
        ViewFactory.getBulletsView(title: R.string.localizable.createAdDescriptionBulletTitle(),
                                   bullets: [R.string.localizable.createAdDescriptionBullet1(),
                                             R.string.localizable.createAdDescriptionBullet2(),
                                             R.string.localizable.createAdDescriptionBullet3()])
    }()

    private lazy var uploadPhotoLabel: UILabel = {
        ViewFactory.createTitle(R.string.localizable.priceSuggestionUploadPhoto())
    }()

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var deleteButton: RoundedButton = {
        let button = RoundedButton(frame: .zero)
        button.setImage(R.image.ic_trash_blue(), for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var selectPhotoButton: SecondaryLargeButton = {
        ViewFactory.createSecondaryButton(text: R.string.localizable.createAdSelectPhotosChooseButton(),
                                          icon: R.image.createAdSelectPhotoGallery(),
                                          buttonColor: R.color.shinyBlue())
    }()

    private lazy var cameraButton: SecondaryLargeButton = {
        ViewFactory.createSecondaryButton(text: R.string.localizable.createAdSelectPhotosNewButton(),
                                          icon: R.image.createAdSelectPhotoNewPhoto(),
                                          buttonColor: R.color.shinyBlue())
    }()

    private lazy var button: PrimaryLargeButton = {
        let button = ViewFactory.createPrimaryButton(text: R.string.localizable.priceSuggestionButton())
        return button
    }()

    private lazy var buttonDescriptionLabel: UILabel = {
        ViewFactory.createLabel(text: R.string.localizable.priceSuggestionButtonHint(), alignment: .center, font: .smallText)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        setupConstraints()
        setupBindings()
    }
}

// MARK: - Private

private extension PriceAdviceViewController {
    func setupNavBar() {
        setNavBar(title: R.string.localizable.priceSuggestionNavbarTitle())
        addCloseButton(image: R.image.ic_close()).rx.tap.bind { [weak self] in
            self?.viewModel.dismiss()
        }.disposed(by: bag)
    }

    func setupView() {
        view.backgroundColor = .white
    }

    func setupBindings() {
        deleteButton.rx.tap.bind(to: viewModel.inputs.delete).disposed(by: bag)
        selectPhotoButton.rx.tap.bind(to: viewModel.inputs.select).disposed(by: bag)
        cameraButton.rx.tap.bind(to: viewModel.inputs.camera).disposed(by: bag)
        viewModel.outputs.image.bind(to: photoImageView.rx.image).disposed(by: bag)
        viewModel.outputs.image.map { $0 == nil }.bind(to: photoImageView.rx.isHidden, deleteButton.rx.isHidden).disposed(by: bag)
        viewModel.outputs.image.map { $0 == nil }.bind(to: selectPhotoButton.rx.isVisible, cameraButton.rx.isVisible).disposed(by: bag)
        viewModel.outputs.image.map { $0 != nil }.bind(to: button.rx.isEnabled).disposed(by: bag)
    }
}

// MARK: - Constraints

private extension PriceAdviceViewController {
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(credentialsLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(phoneNumberTextField)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(bulletsView.0)
        scrollView.addSubview(bulletsView.1)
        scrollView.addSubview(uploadPhotoLabel)
        scrollView.addSubview(photoImageView)
        scrollView.addSubview(deleteButton)
        scrollView.addSubview(selectPhotoButton)
        scrollView.addSubview(cameraButton)
        scrollView.addSubview(button)
        scrollView.addSubview(buttonDescriptionLabel)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            credentialsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            credentialsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            credentialsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.topAnchor.constraint(equalTo: credentialsLabel.bottomAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),

            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 56),

            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 115),

            bulletsView.0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bulletsView.0.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            bulletsView.0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bulletsView.1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bulletsView.1.topAnchor.constraint(equalTo: bulletsView.0.bottomAnchor, constant: 4),
            bulletsView.1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            uploadPhotoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            uploadPhotoLabel.topAnchor.constraint(equalTo: bulletsView.1.bottomAnchor, constant: 32),
            uploadPhotoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: uploadPhotoLabel.bottomAnchor, constant: 16),
            photoImageView.widthAnchor.constraint(equalToConstant: 103),
            photoImageView.heightAnchor.constraint(equalToConstant: 103),

            deleteButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),

            selectPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectPhotoButton.topAnchor.constraint(equalTo: uploadPhotoLabel.bottomAnchor, constant: 32),
            selectPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectPhotoButton.heightAnchor.constraint(equalToConstant: 48),

            cameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cameraButton.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 8),
            cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cameraButton.heightAnchor.constraint(equalToConstant: 48),

            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 32),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48),

            buttonDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonDescriptionLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
            buttonDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
}
