//
//  CreateAdSelectPhotosViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 17/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import OpalImagePicker
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import TLPhotoPicker
import Photos
import Resolver
import UIKit

class CreateAdSelectPhotosViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdSelectPhotosViewModel!
    private var photosView: UICollectionView!
    private var photosTopConstraint: NSLayoutConstraint!
    private var photosHeightConstraint: NSLayoutConstraint!
    private let numImagesCol: CGFloat = 3
    private var rootScrollview: UIScrollView!

    @Injected fileprivate var adCreator: ADCreator

    override func viewDidLoad() {
        super.viewDidLoad()

        analyticsKey = "AdCreation_PhotoSection"
        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)
        rootScrollview = scrollView.scroll

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdSelectPhotosTitle())
        root.addSubview(title)
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        photosView = createPhotosCollectionView()
        photosView.delegate = self
        root.addSubview(photosView)
        photosView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        photosTopConstraint = photosView.alignBelow(view: title, withPadding: 0)
        photosHeightConstraint = photosView.setHeightAnchor(0)

        viewModel.outputs.mediaCells
            .map { $0.count }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] total in
                guard let self = self else { return }
                if total == 0 {
                    self.photosTopConstraint.constant = 0
                    self.photosHeightConstraint.constant = 0
                } else {
                    self.photosTopConstraint.constant = 16
                    let rows = CGFloat(total) / self.numImagesCol
                    let numRows = max(rows.rounded(.up), 1)
                    let height = numRows * self.cellWidth() + (UIConstants.margin * (numRows - 1))
                    self.photosHeightConstraint.constant = height.rounded(.up)
                }
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: bag)

        let dragTip = ViewFactory.createLabel(text: R.string.localizable.createAdSelectPhotosDragTip(), font: UIConstants.descriptionFont)
        root.addSubview(dragTip)
        let dragHeight = dragTip.setHeightAnchor(0)
        dragHeight.isActive = false
        dragTip.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        let dragBottom = dragTip.alignBelow(view: photosView, withPadding: 8)
        viewModel.outputs.mediaCells.map { $0.isEmpty }.bind(to: dragTip.rx.isHidden).disposed(by: bag)
        viewModel.outputs.mediaCells.map { $0.isEmpty ? 0.0 : 8.0 }.bind(to: dragBottom.rx.constant).disposed(by: bag)
        viewModel.outputs.mediaCells.map { !$0.isEmpty }.bind(to: dragHeight.rx.active).disposed(by: bag)

        let selectPhotoButton = ViewFactory.createSecondaryButton(text: R.string.localizable.createAdSelectPhotosChooseButton(),
                                                                  icon: R.image.createAdSelectPhotoGallery(),
                                                                  buttonColor: R.color.shinyBlue())
        root.addSubview(selectPhotoButton)

        selectPhotoButton.analyticsKey = "ChooseExistingPhotos"
        selectPhotoButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        selectPhotoButton.alignBelow(view: dragTip, withPadding: 24)
        selectPhotoButton.setHeightAnchor(UIConstants.buttonHeight)
        selectPhotoButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.selectExistingPhotos(self)
        }.disposed(by: bag)

        let cameraButton = ViewFactory.createSecondaryButton(text: R.string.localizable.createAdSelectPhotosNewButton(),
                                                             icon: R.image.createAdSelectPhotoNewPhoto(),
                                                             buttonColor: R.color.shinyBlue())
        root.addSubview(cameraButton)

        cameraButton.analyticsKey = "TakeNewPhotos"
        cameraButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        cameraButton.alignBelow(view: selectPhotoButton, withPadding: 8)
        cameraButton.setHeightAnchor(UIConstants.buttonHeight)
        cameraButton.rx.tap.bind { [weak self] in
            self?.viewModel.openCameraScreen()
        }.disposed(by: bag)

        let bulletsView = ViewFactory.getBulletsView(title: R.string.localizable.createAdSelectPhotosBulletTitle(),
                                                     bullets: viewModel.getBulletText())
        let bulletTitle = bulletsView.0
        let bullets = bulletsView.1

        root.addSubview(bulletTitle)
        bulletTitle.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        bulletTitle.alignBelow(view: cameraButton, withPadding: 16)

        root.addSubview(bullets)
        bullets.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        bullets.alignBelow(view: bulletTitle, withPadding: 6)

        let horizontal = ViewFactory.createHorizontalStack()
        horizontal.alignment = .leading
        horizontal.distribution = .fill
        root.addSubview(horizontal)
        horizontal.pinToEdges(of: root, orientation: .horizontal)
        let warningTopConstraint = horizontal.alignBelow(view: bullets, withPadding: 18)

        let mediaWarning = ViewFactory.createWarningView(text: R.string.localizable.create_ad_main_warning_min_5_photos())
        horizontal.addArrangedSubview(mediaWarning)
        horizontal.pinToEdges(of: horizontal, orientation: .vertical)
        mediaWarning.isHidden = true

        viewModel.outputs.mediaError
            .bind(to: mediaWarning.rx.isVisible)
            .disposed(by: bag)

        viewModel.outputs.mediaError
            .map { $0 ? 18 : 0 }
            .bind(to: warningTopConstraint.rx.constant)
            .disposed(by: bag)

        let buttonText = nextButtonText(viewModel, R.string.localizable.commonNextStepButton())
        let nextButton = ViewFactory.createPrimaryButton(text: buttonText)
        nextButton.analyticsKey = "NextStep"
        root.addSubview(nextButton)
        nextButton.alignBelow(view: horizontal, withPadding: 16)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in self?.viewModel.next() }.disposed(by: bag)

        viewModel.outputs.saveEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)

        addCloseButtonIfRequired(viewModel)

        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), enabled: true, transparent: false)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }

    private func cellWidth() -> CGFloat {
        let gapSize = UIConstants.margin * (numImagesCol - 1)
        let width = (photosView.bounds.width - gapSize) / numImagesCol
        return width.rounded(.down)
    }

    private func createPhotosCollectionView() -> UICollectionView {
        let layout = RAReorderableLayout()
        let photosView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photosView.translatesAutoresizingMaskIntoConstraints = false
        photosView.backgroundColor = .clear
        photosView.isScrollEnabled = false
        photosView.register(UINib(nibName: SelectPhotoMediaCell.nibName, bundle: nil), forCellWithReuseIdentifier: SelectPhotoMediaCell.identifier)

        viewModel.outputs.mediaCells.bind(to: photosView.rx.items(cellIdentifier: SelectPhotoMediaCell.identifier, cellType: SelectPhotoMediaCell.self)) { [weak self] _, item, cell in
            guard let self = self else { return }
            cell.setUp(with: item)
            cell.delegate = self
        }.disposed(by: bag)

        return photosView
    }
}

// MARK: - UICollectionViewDelegate

extension CreateAdSelectPhotosViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        viewModel.canSelectPhoto(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateAdSelectPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = cellWidth()
        return CGSize(width: width, height: width)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        UIConstants.margin
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        UIConstants.margin
    }
}

// MARK: - RAReorderableLayoutDelegate

extension CreateAdSelectPhotosViewController: RAReorderableLayoutDelegate {
    func collectionView(_: UICollectionView, at: IndexPath, didMoveTo toIndexPath: IndexPath) {
        viewModel.movePhoto(from: at.row, to: toIndexPath.row)
    }

    func collectionView(_: UICollectionView, collectionView _: RAReorderableLayout, didBeginDraggingItemAt _: IndexPath) {
        rootScrollview.isScrollEnabled = false
    }

    func collectionView(_: UICollectionView, collectionView _: RAReorderableLayout, didEndDraggingItemTo _: IndexPath) {
        rootScrollview.isScrollEnabled = true
        photosView.reloadData()
    }

    func collectionView(_: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        viewModel.canMovePhoto(at: indexPath.row)
    }

    func collectionView(_: UICollectionView, at: IndexPath, canMoveTo: IndexPath) -> Bool {
        viewModel.canMovePhoto(at: at.row, to: canMoveTo.row)
    }
}

// MARK: - SelectPhotoMediaCellDelegate

extension CreateAdSelectPhotosViewController: SelectPhotoMediaCellDelegate {
    func cellDidPressCloseButton(_ cell: SelectPhotoMediaCell) {
        let i = photosView.indexPath(for: cell)!.row
        viewModel.removePhoto(at: i)
    }

    func cellDidPressEditButton(_ cell: SelectPhotoMediaCell) {
        let i = photosView.indexPath(for: cell)!.row
        viewModel.cropPhoto(at: i)
    }
}

// MARK: - TLPhotosPickerViewControllerDelegate

extension CreateAdSelectPhotosViewController: TLPhotosPickerViewControllerDelegate {
 
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        let manager = PHImageManager()
        
        manager.fetchImages(assets: withPHAssets, imageFetched: nil) { images in
            guard images.first != nil else { return }
            
            DispatchQueue.global().async {
                for image in images {
                    // Scale down to reduce bandwidth
                    let scaledImage = image.scaledToMaxWidth(CGFloat(ProductConfig.maxImageLengthPixels))
                    self.viewModel.addPhoto(adPhoto: AdPhoto.new(data: scaledImage))
                    DispatchQueue.main.async {
                        self.photosView.reloadData()
                    }
                }
            }
        }
    }
   
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        let alertController = UIAlertController(title: "",
                                                message: R.string.localizable.select_photos_max_exceeded("\(adCreator.mediaManager.maxPhotoSelectionAllowed)"),
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: R.string.localizable.merchant_profile_incomplete_dialog_ok_button(),
                                   style: .cancel, handler: nil)
        alertController.addAction(action)
        picker.present(alertController, animated: true, completion: nil)
    }
}
