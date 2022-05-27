//
//  PublicProfileViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import Kingfisher
import Photos
import RxSwift
//import Segmentio
import WhoppahCore
import TLPhotoPicker
import WhoppahCoreNext
import Resolver
import UIKit

class PublicProfileViewController: UIViewController {
    var viewModel: PublicProfileViewModel!

    // MARK: - IBOutlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var verifiedView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var userAboutLabel: UILabel!
    @IBOutlet var userActivePeriod: UILabel!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var editAvatarIcon: UIButton!
    @IBOutlet var editBackgroundIcon: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var profileTextView: UIView!
    @IBOutlet var topbarGradient: GradientHeaderView!
    @IBOutlet var backgroundBlur: UIVisualEffectView!

    @IBOutlet var backgroundViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var avatarImageTopConstraint: NSLayoutConstraint!
    @IBOutlet var avatarImageWidth: NSLayoutConstraint!
    @IBOutlet var avatarOffsetX: NSLayoutConstraint!
    @IBOutlet var profileNameTopConstraint: NSLayoutConstraint!
    @IBOutlet var profileLeftTopConstraint: NSLayoutConstraint!
    @IBOutlet var cityCenterConstraint: NSLayoutConstraint!

    @IBOutlet var separatorTopConstraint: NSLayoutConstraint!
    @IBOutlet var separatorBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private var initialContainerHeight: CGFloat?
    private var activeAdsNavigation: UINavigationController!
    private var currentViewController: UIViewController?
    private let bag = DisposeBag()
    
    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpControllers()
        setUpButtons()
        setUpAvatarView()
        setUpViewModel()

        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Private

    private func setUpControllers() {
        activeAdsNavigation = UINavigationController()
        activeAdsNavigation.isNavigationBarHidden = true
        // Need to wait for the merchant to be fetched before setting up the ad list
        viewModel.outputs.onMerchantFetched
            .observeOn(MainScheduler.instance)
            .compactMap { $0 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                let coordinator = ProfileAdListCoordinator(navigationController: self.activeAdsNavigation)
                self.viewModel.setupProfileCoordinator(coordinator: coordinator, delegate: self, listType: .active)
            }).disposed(by: bag)
    }

    private func setUpView() {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        let navC: UINavigationController = activeAdsNavigation
        addChild(navC)
        navC.view.frame = containerView.bounds
        containerView.addSubview(navC.view)
        navC.didMove(toParent: self)
        currentViewController = navC
    }

    private func setUpButtons() {
        let canEdit = viewModel.showEditControls()
        editProfileButton.makeCircular()
        editProfileButton.isVisible = canEdit

        editBackgroundIcon.makeCircular()
        editBackgroundIcon.isVisible = canEdit

        editAvatarIcon.makeCircular()
        editAvatarIcon.isVisible = canEdit

        moreButton.isVisible = !canEdit
    }

    private func setUpAvatarView() {
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = UIColor.white.cgColor
    }

    private func setUpViewModel() {
        viewModel.outputs.uiData.compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.updateData(data: data)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        viewModel.outputs.error.subscribe(onNext: { [weak self] error in
            self?.showError(error)
        }).disposed(by: bag)
    }

    private func updateData(data: ProfileUIData) {
        avatarView.setIcon(forUrl: data.avatar, cacheKey: data.avatarId?.uuidString, character: data.avatarCharacter)
        backgroundImageView.setIcon(forUrl: data.background, cacheKey: data.backgroundId?.uuidString, character: data.avatarCharacter)
        usernameLabel.text = data.name
        if let city = data.city {
            cityLabel.text = city
            cityLabel.isHidden = false
        } else {
            cityLabel.isHidden = true
        }
        verifiedView.isVisible = data.isVerified
        if let about = data.about {
            userAboutLabel.text = about
            userAboutLabel.isHidden = false
        } else {
            userAboutLabel.isHidden = true
        }
        userActivePeriod.text = data.activePeriod
        
        if data.isBusiness {
            backgroundImageView.isHidden = true
            avatarView.isHidden = true
            avatarImageWidth.constant = 0
        }

        setUpButtons()
    }

    // MARK: - Actions

    @IBAction func editProfileAction(_: UIButton) {
        viewModel.editProfile()
    }

    @IBAction func backAction(_: UIButton) {
        viewModel.coordinator.dismiss()
    }

    @IBAction func editAvatar(_: UIButton) {
        viewModel.coordinator.editProfileAvatar(delegate: self)
    }

    @IBAction func editBackground(_: UIButton) {
        viewModel.coordinator.editProfileCover(delegate: self)
    }

    @IBAction func morePressed(_: UIButton) {
        viewModel.showReportMenu()
    }
}

// MARK: ProfileAvatarPickerDelegate

extension PublicProfileViewController: ProfileAvatarPickerDelegate {
    func photoPicked(image: UIImage) {
        avatarView.showLoading()
        DispatchQueue.global().async {
            let scaledImage = image.scaledToMaxWidth(600)
            guard let photo = scaledImage.jpegData(compressionQuality: 0.8) else { return }
            self.viewModel?.uploadAvatarImage(image: photo) { [weak self] result in
                switch result {
                case let .success(id):
                    let cache = Kingfisher.ImageCache.default
                    cache.store(scaledImage, forKey: id.uuidString, toDisk: false)
                case let .failure(error):
                    self?.avatarView.hideLoading()
                    self?.showError(error)
                }
            }
        }
    }
}

// MARK: - TLPhotosPickerViewControllerDelegate

extension PublicProfileViewController: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
         guard !withPHAssets.isEmpty else { return }
        
         let manager = PHImageManager()
         manager.fetchImages(assets: withPHAssets, imageFetched: nil) { images in
            guard let image = images.first else { return }
            self.backgroundImageView.showLoading()
            DispatchQueue.global().async {
                let scaledImage = image.scaledToMaxWidth(1000)
                guard let photo = scaledImage.jpegData(compressionQuality: 0.8) else { return }
                self.viewModel?.uploadBackgroundImage(image: photo) { [weak self] result in
                    switch result {
                    case let .success(id):
                        let cache = Kingfisher.ImageCache.default
                        cache.store(scaledImage, forKey: id.uuidString, toDisk: false)
                    case let .failure(error):
                        self?.backgroundImageView.hideLoading()
                        self?.showError(error)
                    }
                }
            }
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

// MARK: ProfileAdListDelegate

extension PublicProfileViewController: ProfileAdListDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let finalY: CGFloat = containerView.frame.minY
        // Don't animate if not enough content
        if initialContainerHeight == nil { initialContainerHeight = containerView.frame.height }
        guard scrollView.contentSize.height - initialContainerHeight! > finalY else { return }
        let avatarFullsizeDimension: CGFloat = 96
        if scrollView.offsetY > 0 {
            backgroundBlur.isVisible = true

            let fractionLinear = min(scrollView.offsetY / finalY, 1.0)
            animateScroll(linearFraction: fractionLinear, avatarFullsizeDimension: avatarFullsizeDimension)
        } else {
            animateScroll(linearFraction: 0.0, avatarFullsizeDimension: avatarFullsizeDimension)
            backgroundBlur.isVisible = false
        }
    }

    private func animateScroll(linearFraction: CGFloat, avatarFullsizeDimension: CGFloat) {
        let topSectionHeight: CGFloat = 86
        let finalAvatarDimension: CGFloat = 56
        let avatarOffsetFromMiddleX = UIScreen.main.bounds.width / 2 - avatarImageWidth.constant / 2 - 46
        let usesAvatar = !avatarView.isHidden

        // Starts at 0 and moves to 1
        let sineEaseOut = sin(linearFraction * .pi / 2)
        // Starts at 1 and moves to 0
        let inverseSineEaseOut = 1 - sineEaseOut

        let p = linearFraction - 1
        // cubic ease out
        let cubicEaseOutFraction = 1 - (p * p * p + 1)
        let cubicEaseIn = linearFraction * linearFraction * linearFraction

        editAvatarIcon.alpha = inverseSineEaseOut
        editProfileButton.alpha = inverseSineEaseOut
        editBackgroundIcon.alpha = inverseSineEaseOut
        userActivePeriod.alpha = cubicEaseOutFraction
        userAboutLabel.alpha = cubicEaseOutFraction
        backgroundBlur.alpha = sineEaseOut
        topbarGradient.gradientOpacity = Float(cubicEaseOutFraction)

        // Move offscreen until only the bottom (same size of top section) is visible
        backgroundViewTopConstraint.constant = -sineEaseOut * (backgroundImageView.frame.height - topSectionHeight)
        // Size of the avatar image
        if usesAvatar {
            avatarImageWidth.constant = finalAvatarDimension + ((avatarFullsizeDimension - finalAvatarDimension) * inverseSineEaseOut)
        }

        // Bring the collection view and separator up to the top
        separatorTopConstraint.constant = 8 * inverseSineEaseOut
        // Need to adjust by the about text (if there) because the stack view doesn't auto-resize nicely when the content fades out
        separatorBottomConstraint.constant = 8 * inverseSineEaseOut
        if userAboutLabel.text?.isEmpty == false {
            separatorBottomConstraint.constant -= userAboutLabel.frame.height * sineEaseOut
        }
        
        guard usesAvatar else { return }

        // Offset the avatar image from the centre of the screen to the left
        avatarOffsetX.constant = -avatarOffsetFromMiddleX * sineEaseOut

        let userHalfWidth = usernameLabel.frame.width / 2
        // Moves wih the avatar image
        // Offset from the centre of the image,
        // half the label width (so it doesn't overlap)
        // and place 16 px to the left
        profileLeftTopConstraint.constant = (finalAvatarDimension / 2 + userHalfWidth + 16) * sineEaseOut
        let cityHalfWidth = cityLabel.frame.width / 2
        cityCenterConstraint.constant = -(userHalfWidth - cityHalfWidth) * sineEaseOut
        // The image starts half offset at the bottom of the background image
        let initialOffset = (-avatarFullsizeDimension / 2) * inverseSineEaseOut
        avatarImageTopConstraint.constant = initialOffset + (-finalAvatarDimension / 2) * sineEaseOut - topSectionHeight / 2 * sineEaseOut
        // 8px for the padding - this brings the view level with the bottom of the avatar
        // Adjust from the top of the avatar downwards, taking into account the height of the textview itself
        profileNameTopConstraint.constant = 8 * (1 - cubicEaseIn) - (finalAvatarDimension - (finalAvatarDimension / 2) + profileTextView.frame.height / 2) * cubicEaseIn
    }
}
