//
//  CreateAnAdSummaryViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 24/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import EasyTipView
import Foundation
import Lightbox
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import UIKit

class CreateAdSummaryViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdSummaryViewModel!
    private weak var scrollView: UIScrollView?
    private var progressView: ProgressView!
    private var fullScreenItems: [LightboxImage] = []
    private var mediaScrollPage = 1 {
        didSet {
            updateMediaCountLabel()
        }
    }

    private weak var mediaScrollView: UIScrollView?
    private var mediaCountLabel: UILabel!
    private let descriptionColor = UIColor(hexString: "#3C3C43", alpha: 0.6)

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), transparent: false)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)
        self.scrollView = scrollView.scroll

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdSummaryTitle())
        root.addSubview(title)
        title.textColor = .black
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let mediaScroll = ViewFactory.createScrollView(orientation: .horizontal)
        mediaScrollView = mediaScroll.scroll
        root.addSubview(mediaScroll.scroll)
        mediaScroll.scroll.delegate = self
        mediaScroll.scroll.horizontalPin(to: root, orientation: .leading)
        mediaScroll.scroll.setEqualsSize(toView: root, orientation: .horizontal)
        mediaScroll.scroll.setAspect(1)
        mediaScroll.scroll.isPagingEnabled = true
        mediaScroll.scroll.alignBelow(view: title, withPadding: 16)
        let mediaScrollRoot = mediaScroll.root

        let mediaCount = ViewFactory.createMediaCountView()
        root.addSubview(mediaCount.root)
        mediaCount.root.center(withView: root, orientation: .horizontal)
        mediaCount.root.verticalPin(to: mediaScrollRoot, orientation: .bottom, padding: -UIConstants.margin)
        mediaCountLabel = mediaCount.text
        updateMediaCountLabel()
        setUpMediaScrollView(mediaScroll)

        let editPhotosButton = ViewFactory.createBlueTextButton(text: R.string.localizable.createAdSummaryEditPhotosButton(),
                                                                image: R.image.editPhotoIcon(),
                                                                font: .descriptionSemibold)
        editPhotosButton.setHeightAnchor(20)

        root.addSubview(editPhotosButton)
        editPhotosButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        editPhotosButton.alignBelow(view: mediaScroll.scroll, withPadding: 16)
        editPhotosButton.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        editPhotosButton.rx.tap.bind { [weak self] in
            self?.viewModel.editPhotos()
        }.disposed(by: bag)

        let editVideoButton = ViewFactory.createBlueTextButton(text: R.string.localizable.createAdSummaryEditVideoButton(),
                                                               image: R.image.editVideoIcon(),
                                                               font: .descriptionSemibold)
        editVideoButton.setHeightAnchor(20)

        root.addSubview(editVideoButton)
        editVideoButton.imageEdgeInsets = UIEdgeInsets(top: editVideoButton.imageEdgeInsets.top,
                                                       left: editVideoButton.imageEdgeInsets.left,
                                                       bottom: editVideoButton.imageEdgeInsets.bottom,
                                                       right: 8)
        editVideoButton.setMinWidthAnchor(121)
        editVideoButton.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
        editVideoButton.center(withView: editPhotosButton, orientation: .vertical)
        editVideoButton.contentHorizontalAlignment = .trailing
        editVideoButton.rx.tap.bind { [weak self] in
            self?.viewModel.editVideo()
        }.disposed(by: bag)

        let descriptionSectionTitle = ViewFactory.createTitle(R.string.localizable.createAdSummaryDescriptionSectionTitle())
        root.addSubview(descriptionSectionTitle)
        descriptionSectionTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        descriptionSectionTitle.alignBelow(view: editPhotosButton, withPadding: 24)

        let adTitle = ViewFactory.createLabel(text: "", font: .descriptionLabel)
        adTitle.numberOfLines = 0
        root.addSubview(adTitle)
        adTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        adTitle.alignBelow(view: descriptionSectionTitle, withPadding: 10)
        viewModel.outputs.title.bind(to: adTitle.rx.text).disposed(by: bag)

        let adDescription = ViewFactory.createLabel(text: "", font: .label)
        adDescription.numberOfLines = 0
        root.addSubview(adDescription)
        adDescription.textColor = descriptionColor
        adDescription.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        adDescription.alignBelow(view: adTitle, withPadding: 8)
        viewModel.outputs.description.bind(to: adDescription.rx.text).disposed(by: bag)

        let editDescriptionButton = ViewFactory.createBlueTextButton(text: R.string.localizable.createAdSummaryDescriptionEditButton(), font: .descriptionSemibold)
        root.addSubview(editDescriptionButton)
        editDescriptionButton.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
        editDescriptionButton.alignBelow(view: adDescription, withPadding: 5)
        editDescriptionButton.rx.tap.bind { [weak self] in
            self?.viewModel.editDescription()
        }.disposed(by: bag)

        let detailsSection = getDetailsSection()
        root.addSubview(detailsSection)
        detailsSection.pinToEdges(of: root, orientation: .horizontal)
        detailsSection.alignBelow(view: editDescriptionButton, withPadding: 32)
        detailsSection.onExpandToggle = { expanded in
            guard expanded else { return }
            scrollView.scroll.contentOffset = CGPoint(x: 0, y: detailsSection.frame.maxY)
        }
        
        let priceSection = getPricingSection()
        root.addSubview(priceSection)
        priceSection.pinToEdges(of: root, orientation: .horizontal)
        priceSection.alignBelow(view: detailsSection)
        priceSection.onExpandToggle = { expanded in
            guard expanded else { return }
            scrollView.scroll.contentOffset = CGPoint(x: 0, y: priceSection.frame.maxY)
        }
        
        let addressSection = getAddressSection()
        root.addSubview(addressSection)
        addressSection.pinToEdges(of: root, orientation: .horizontal)
        addressSection.alignBelow(view: priceSection)
        addressSection.onExpandToggle = { expanded in
            guard expanded else { return }
            scrollView.scroll.contentOffset = CGPoint(x: 0, y: addressSection.frame.maxY)
        }

        let dummy = ViewFactory.createView()
        root.addSubview(dummy)
        dummy.pinToEdges(of: root, orientation: .horizontal)
        dummy.alignBelow(view: addressSection, withPadding: 80)
        root.verticalPin(to: dummy, orientation: .bottom, padding: 24)

        let nextButton = ViewFactory.createPrimaryButton(text: "")
        viewModel.outputs.nextButton.bind(to: nextButton.rx.title(for: .normal)).disposed(by: bag)
        viewModel.outputs.saving.bind(to: nextButton.rx.isAnimating).disposed(by: bag)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.next()
        }.disposed(by: bag)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)

        let nextDescription = ViewFactory.createLabel(text: R.string.localizable.createAdSummaryCreateButtonDescription(), font: UIConstants.descriptionFont)
        nextDescription.numberOfLines = 0
        viewModel.outputs.nextButtonDescriptionVisible.bind(to: nextDescription.rx.isVisible).disposed(by: bag)
        
        let nextBackgroundStackView = ViewFactory.createVerticalStack()
        view.addSubview(nextBackgroundStackView)
        nextBackgroundStackView.horizontalPin(to: view, orientation: .leading)
        nextBackgroundStackView.horizontalPin(to: view, orientation: .trailing)
        nextBackgroundStackView.verticalPin(to: view, orientation: .bottom)
        nextBackgroundStackView.distribution = .fill
        nextBackgroundStackView.backgroundColor = .white
        nextBackgroundStackView.isLayoutMarginsRelativeArrangement = true
        nextBackgroundStackView.layoutMargins = UIEdgeInsets(top: UIConstants.margin, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
        nextBackgroundStackView.spacing = UIConstants.margin
        nextBackgroundStackView.addArrangedSubview(nextButton)
        nextBackgroundStackView.addArrangedSubview(nextDescription)
        
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        
        progressView = createProgressView()
        setUpProgressIndicator(progressView: progressView)
        view.addSubview(progressView.root)
        progressView.root.alignAbove(view: nextBackgroundStackView, withPadding: -4)
        progressView.root.pinToEdges(of: view, orientation: .horizontal, padding: UIConstants.margin)
        updateProgressButton()
        
        view.verticalPin(to: nextDescription, orientation: .bottom, padding: 16)
        
        addCloseButtonIfRequired(viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }

    private func setUpMediaScrollView(_ mediaScroll: ViewFactory.ScrollViews) {
        let scrollView = mediaScroll.scroll
        let root = mediaScroll.root
        Observable.combineLatest(viewModel.outputs.media.images, viewModel.outputs.media.videos)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self, weak root, weak scrollView] result in
                guard let self = self else { return }
                guard let scrollView = scrollView, let root = root else { return }

                for view in root.subviews {
                    view.removeFromSuperview()
                }

                let horizStack = ViewFactory.createHorizontalStack()
                horizStack.alignment = .center
                horizStack.distribution = .equalCentering
                var mediaViews: [MediaView] = []
                self.mediaScrollPage = 1

                scrollView.setContentOffset(CGPoint.zero, animated: true)
                self.fullScreenItems.removeAll()
                for image in result.0 {
                    guard case let .photo(finalImage) = image.state else {
                        continue
                    }
                    let mediaView = ViewFactory.createMediaView()

                    mediaView.thumbnailView.layer.masksToBounds = true
                    mediaView.thumbnailView.contentMode = .scaleAspectFill
                    mediaView.thumbnailView.image = finalImage
                    mediaViews.append(mediaView)

                    if let lightImage = finalImage {
                        self.fullScreenItems.append(LightboxImage(image: lightImage))
                    } else if let placeholder = R.image.image_placeholder() {
                        self.fullScreenItems.append(LightboxImage(image: placeholder))
                    }
                }

                if let video = result.1.first, case let .video(thumbnail, data, path) = video.state {
                    let mediaView = ViewFactory.createMediaView()
                    mediaView.thumbnailView.layer.masksToBounds = true
                    mediaView.thumbnailView.image = thumbnail
                    mediaView.thumbnailView.contentMode = .scaleAspectFill

                    if let path = path {
                        mediaView.configure(videoUrl: path)
                    } else if let data = data {
                        mediaView.configure(data: data)
                    }

                    if let url = mediaView.videoUrl {
                        let idx = mediaViews.isEmpty ? 0 : 1
                        if let thumbnail = thumbnail {
                            self.fullScreenItems.insert(LightboxImage(image: thumbnail, text: "", videoURL: url), at: idx)
                        } else {
                            self.fullScreenItems.insert(LightboxImage(image: R.image.image_placeholder()!, text: "", videoURL: url), at: idx)
                        }

                        mediaViews.insert(mediaView, at: idx)
                    }
                }

                for (index, element) in mediaViews.enumerated() {
                    horizStack.addArrangedSubview(element)
                    element.setEqualsSize(toView: horizStack, orientation: .vertical)
                    element.widthAnchor.constraint(equalTo: element.heightAnchor, multiplier: 1.0).isActive = true
                    element.index = index
                    element.delegate = self
                }
                root.addSubview(horizStack)
                horizStack.horizontalPin(to: root, orientation: .leading)
                horizStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(mediaViews.count)).isActive = true
                root.horizontalPin(to: horizStack, orientation: .trailing)
                horizStack.pinToEdges(of: root, orientation: .vertical)
            }).disposed(by: bag)
    }
}

// MARK: Description section

extension CreateAdSummaryViewController {
    func getDetailsSection() -> ExpandableSection {
        let section = ExpandableSection(title: R.string.localizable.createAdSummaryProductdetailsTitle())
        section.translatesAutoresizingMaskIntoConstraints = false

        let brandSection = ViewFactory.createTextRowView(left: viewModel.brandOrArtistTitle, right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(brandSection.root)
        brandSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let brandText = brandSection.rightText {
            viewModel.outputs.details.brandOrArtist.bind(to: brandText.rx.text).disposed(by: bag)
        }

//        let materialSection = ViewFactory.createTextRowView(left: R.string.localizable.commonMaterialTitle(), right: "-", rightTextColor: descriptionColor)
//        section.contentView.addArrangedSubview(materialSection.root)
//        materialSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
//        if let materialText = materialSection.rightText {
//            viewModel.outputs.details.materials.bind(to: materialText.rx.text).disposed(by: bag)
//        }

        let conditionSection = ViewFactory.createTextRowView(left: R.string.localizable.commonConditionTitle(), right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(conditionSection.root)
        conditionSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let conditionText = conditionSection.rightText {
            viewModel.outputs.details.condition.bind(to: conditionText.rx.text).disposed(by: bag)
        }

        let dimensionsSection = ViewFactory.createTextRowView(left: R.string.localizable.commonDimensionsTitle(), right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(dimensionsSection.root)
        dimensionsSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let dimensionText = dimensionsSection.rightText {
            viewModel.outputs.details.dimensions.bind(to: dimensionText.rx.text).disposed(by: bag)
        }

        let colorsView = ViewFactory.createView()
        viewModel.outputs.details.colors.subscribe(onNext: { [weak self] colors in
            colorsView.subviews.forEach {
                $0.removeFromSuperview()
            }
            guard !colors.isEmpty else {
                guard let self = self else { return }
                let empty = ViewFactory.createLabel(text: "-")
                colorsView.addSubview(empty)
                empty.verticalPin(to: colorsView, orientation: .top)
                empty.horizontalPin(to: colorsView, orientation: .trailing)
                empty.textColor = self.descriptionColor
                return
            }
            let itemsPerRow = 8
            for (index, colorVM) in colors.enumerated() {
                let colorCell = ColorCell()
                colorCell.translatesAutoresizingMaskIntoConstraints = false
                colorCell.setUp(with: colorVM)
                colorCell.setSize(16, 16)
                let last = colorsView.subviews.last
                colorsView.addSubview(colorCell)
                let column = index % itemsPerRow
                if let lastView = last, column != 0 {
                    colorCell.alignBefore(view: lastView, withPadding: -8)
                    colorCell.center(withView: lastView, orientation: .vertical)
                } else {
                    colorCell.horizontalPin(to: colorsView, orientation: .trailing)
                    if let lastView = last {
                        colorCell.alignBelow(view: lastView, withPadding: 8)
                    } else {
                        colorCell.verticalPin(to: colorsView, orientation: .top)
                    }
                }
            }
            if let first = colorsView.subviews.first {
                colorsView.horizontalPin(to: first, orientation: .leading)
            }
            if let last = colorsView.subviews.last {
                colorsView.verticalPin(to: last, orientation: .bottom)
            }
        }).disposed(by: bag)

        let colorsSection = ViewFactory.createTextRowView(left: R.string.localizable.commonColorsTitle(), customRightView: colorsView)
        colorsSection.leftText.setMinWidthAnchor(100)
        section.contentView.addArrangedSubview(colorsSection.root)
        colorsSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)

        let bottomView = ViewFactory.createView()
        let editSectionTitle = ViewFactory.createBlueTextButton(text: R.string.localizable.createAdSummaryEditProductdetailsButton(),
                                                                font: .descriptionSemibold)
        editSectionTitle.rx.tap.bind { [weak self] in
            self?.viewModel.editDetails()
        }.disposed(by: bag)

        bottomView.addSubview(editSectionTitle)
        editSectionTitle.horizontalPin(to: bottomView, orientation: .trailing, padding: -UIConstants.margin)
        editSectionTitle.verticalPin(to: bottomView, orientation: .top, padding: 16)
        bottomView.verticalPin(to: editSectionTitle, orientation: .bottom, padding: 24)

        section.contentView.addArrangedSubview(bottomView)
        bottomView.pinToEdges(of: section.contentView, orientation: .horizontal)

        section.toggleExpand(false, animate: false)
        return section
    }
}

// MARK: Price section

extension CreateAdSummaryViewController {
    func getPricingSection() -> ExpandableSection {
        let section = ExpandableSection(title: R.string.localizable.createAdSummaryPriceTitle())
        section.translatesAutoresizingMaskIntoConstraints = false

        let askingPriceSection = ViewFactory.createTextRowView(left: R.string.localizable.createAdSummaryPriceTitle(), right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(askingPriceSection.root)
        askingPriceSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let priceText = askingPriceSection.rightText {
            viewModel.outputs.price.asking.bind(to: priceText.rx.text).disposed(by: bag)
        }

        let biddingSection = ViewFactory.createTextRowView(left: R.string.localizable.createAdSummaryBiddingEnabledTitle(), right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(biddingSection.root)
        biddingSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let bidText = biddingSection.rightText {
            viewModel.outputs.price.biddingEnabled.bind(to: bidText.rx.text).disposed(by: bag)
        }

        let bottomView = ViewFactory.createView()
        let editSectionTitle = ViewFactory.createBlueTextButton(text: R.string.localizable.createAdSummaryEditPriceButton(),
                                                                font: .descriptionSemibold)
        editSectionTitle.rx.tap.bind { [weak self] in
            self?.viewModel.editPrice()
        }.disposed(by: bag)

        bottomView.addSubview(editSectionTitle)
        editSectionTitle.horizontalPin(to: bottomView, orientation: .trailing, padding: -UIConstants.margin)
        editSectionTitle.verticalPin(to: bottomView, orientation: .top, padding: 16)
        bottomView.verticalPin(to: editSectionTitle, orientation: .bottom, padding: 24)

        section.contentView.addArrangedSubview(bottomView)
        bottomView.pinToEdges(of: section.contentView, orientation: .horizontal)

        section.toggleExpand(false, animate: false)
        return section
    }
}

// MARK: Address section

extension CreateAdSummaryViewController {
    func getAddressSection() -> ExpandableSection {
        let section = ExpandableSection(title: R.string.localizable.createAdSummaryShippingMethodTitle())
        section.translatesAutoresizingMaskIntoConstraints = false

        let addressSection = ViewFactory.createTextRowView(left: R.string.localizable.createAdSummaryShippingAddressTitle(), right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(addressSection.root)
        addressSection.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let addressText = addressSection.rightText {
            viewModel.outputs.shipping.address.bind(to: addressText.rx.text).disposed(by: bag)
        }

        let shippingMethod = ViewFactory.createTextRowView(left: R.string.localizable.createAdSummaryShippingMethodTitle(), right: "-", rightTextColor: descriptionColor)
        section.contentView.addArrangedSubview(shippingMethod.root)
        shippingMethod.root.pinToEdges(of: section.contentView, orientation: .horizontal)
        if let priceText = shippingMethod.rightText {
            viewModel.outputs.shipping.method.bind(to: priceText.rx.text).disposed(by: bag)
        }

        let bottomView = ViewFactory.createView()
        let editSectionTitle = ViewFactory.createBlueTextButton(text: R.string.localizable.createAdSummaryEditShippingButton(),
                                                                font: .descriptionSemibold)
        editSectionTitle.rx.tap.bind { [weak self] in
            self?.viewModel.editShipping()
        }.disposed(by: bag)

        bottomView.addSubview(editSectionTitle)
        editSectionTitle.horizontalPin(to: bottomView, orientation: .trailing, padding: -UIConstants.margin)
        editSectionTitle.verticalPin(to: bottomView, orientation: .top, padding: 16)
        bottomView.verticalPin(to: editSectionTitle, orientation: .bottom, padding: 24)

        section.contentView.addArrangedSubview(bottomView)
        bottomView.pinToEdges(of: section.contentView, orientation: .horizontal)

        section.toggleExpand(false, animate: false)
        return section
    }
}

// MARK: Progress

extension CreateAdSummaryViewController {
    struct ProgressView {
        let root: UIView
        let indicator: UIProgressView
        let text: UILabel
        var progress = [UUID: HTTPProgress]()
    }

    private func createProgressView() -> ProgressView {
        let root = ViewFactory.createView()
        let progressText = ViewFactory.createLabel(text: "", font: .descriptionText)
        root.addSubview(progressText)
        progressText.horizontalPin(to: root, orientation: .trailing)
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(progressBar)
        progressBar.tintColor = .shinyBlue
        progressBar.trackTintColor = .clear
        progressBar.pinToEdges(of: root, orientation: .horizontal)
        progressBar.verticalPin(to: root, orientation: .bottom)
        progressText.alignAbove(view: progressBar)
        root.verticalPin(to: progressText, orientation: .top)

        return ProgressView(root: root, indicator: progressBar, text: progressText)
    }

    private func setUpProgressIndicator(progressView: ProgressView) {
        viewModel.outputs.saving.subscribe(onNext: { [weak self] saving in
            guard let self = self else { return }
            if saving {
                self.progressView.indicator.isVisible = true
                self.progressView.text.isVisible = true
            } else {
                self.progressView.indicator.isVisible = false
                self.progressView.indicator.progress = 0.0
                self.progressView.text.isVisible = false
                self.progressView.text.text = ""
            }
        }).disposed(by: bag)
        progressView.indicator.isVisible = false
        progressView.text.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(uploadProgressChanged), name: adMediaProgress, object: nil)
    }

    @objc private func uploadProgressChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let userInfo = notification.userInfo, let progressData = userInfo["progress"] as? HTTPProgress else {
                return
            }
            self.progressView.progress[progressData.id] = progressData
            self.updateProgressButton()
        }
    }

    private func updateProgressButton() {
        let hasProgress = !progressView.progress.isEmpty

        if hasProgress {
            var totalBytes: Int64 = 0
            var totalProgressBytes: Int64 = 0
            for progress in progressView.progress {
                totalProgressBytes += progress.value.totalDownloaded
                totalBytes += progress.value.totalSizeBytes
            }
            guard totalBytes > 0 else { return }
            let fraction = Float(totalProgressBytes) / Float(totalBytes)
            progressView.indicator.progress = fraction
            if fraction < 1.0 {
                progressView.text.text = String(format: "%.1f%%", fraction * 100.0)
            } else {
                progressView.text.text = R.string.localizable.progress_finishing()
            }
        } else {
            progressView.text.text = ""
            progressView.indicator.progress = 0.0
        }
    }
}

extension CreateAdSummaryViewController: MediaViewDelegate {
    func mediaViewDidSelect(_: MediaView, at index: Int?) {
        let controller = LightboxController(images: fullScreenItems, startIndex: index ?? 0)
        controller.dynamicBackground = true
        controller.modalPresentationStyle = UIDevice.current.userInterfaceIdiom != .pad ? .fullScreen : .currentContext
        present(controller, animated: true, completion: nil)
    }

    func videoDidEnd() {}
    func videoDidStart(_: MediaView) {}
}

// MARK: - UIScrollViewDelegate

extension CreateAdSummaryViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_: UIScrollView) {
        scrollView?.isScrollEnabled = false
    }

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        scrollView?.isScrollEnabled = true
    }

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate _: Bool) {
        scrollView?.isScrollEnabled = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mediaScrollView, let mediaScrollView = mediaScrollView {
            let pageIndex = round(mediaScrollView.contentOffset.x / mediaScrollView.frame.width)
            let nextPage = Int(pageIndex) + 1
            if nextPage != mediaScrollPage {
                mediaScrollPage = nextPage
                let mediaIndex = Int(pageIndex)
                // Autoplay video when it appears
                let item = fullScreenItems[mediaIndex]
                if item.videoURL != nil {
                    if mediaIndex < mediaScrollView.subviews.count, let video = mediaScrollView.subviews[mediaIndex] as? MediaView {
                        video.play()
                    }
                }
            }
        }
    }

    private func updateMediaCountLabel() {
        mediaCountLabel.text = "\(mediaScrollPage) / \(viewModel.mediaCount)"
    }

    struct TooltipRow {
        let root: UIView
        let leftText: UILabel
        let rightText: UILabel
    }

    private func createTextRowView(left: String,
                                   right: String,
                                   rightTextColor _: UIColor? = nil) -> TooltipRow {
        let root = ViewFactory.createView()
        let leftView = ViewFactory.createLabel(text: left, font: .descriptionText)
        leftView.textColor = .white
        root.addSubview(leftView)
        leftView.horizontalPin(to: root, orientation: .leading)
        leftView.verticalPin(to: root, orientation: .top)
        leftView.setMinWidthAnchor(120)
        leftView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 100), for: .horizontal)

        let rightView = ViewFactory.createLabel(text: right, alignment: .right, font: .descriptionText)
        rightView.numberOfLines = 1
        rightView.textColor = .white
        root.addSubview(rightView)
        rightView.horizontalPin(to: root, orientation: .trailing)
        rightView.center(withView: root, orientation: .vertical)
        rightView.verticalPin(to: leftView, orientation: .top)
        rightView.heightAnchor.constraint(greaterThanOrEqualTo: leftView.heightAnchor, multiplier: 1).isActive = true
        root.verticalPin(to: rightView, orientation: .bottom)
        leftView.alignBefore(view: rightView, withPadding: -24)

        return TooltipRow(root: root, leftText: leftView, rightText: rightView)
    }
}
