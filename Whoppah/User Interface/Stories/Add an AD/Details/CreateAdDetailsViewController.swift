//
//  CreateAdDetailsViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 21/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CreateAdDetailsViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdDetailsViewModel!
    private var colorsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        analyticsKey = "AdCreation_DetailsSection"
        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), transparent: false)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdDetailsTitle())
        root.addSubview(title)
        title.textColor = .black
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let subtitle = ViewFactory.createLabel(text: R.string.localizable.createAdDetailsSubtitle(), font: UIConstants.descriptionFont)
        root.addSubview(subtitle)
        subtitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        subtitle.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)

        let dividerTop = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(dividerTop)
        dividerTop.pinToEdges(of: root, orientation: .horizontal)
        dividerTop.alignBelow(view: subtitle, withPadding: 16)

        let brandSection = getBrandSection()
        root.addSubview(brandSection.root)
        brandSection.root.pinToEdges(of: root, orientation: .horizontal)
        brandSection.root.alignBelow(view: dividerTop)

        let dividerBrand = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(dividerBrand)
        dividerBrand.pinToEdges(of: root, orientation: .horizontal)
        dividerBrand.alignBelow(view: brandSection.root)

//        let materialSection = getMaterialSection()
//        root.addSubview(materialSection.root)
//        materialSection.root.pinToEdges(of: root, orientation: .horizontal)
//        materialSection.root.alignBelow(view: dividerBrand)
//
//        let dividerMaterial = ViewFactory.createDivider(orientation: .horizontal)
//        root.addSubview(dividerMaterial)
//        dividerMaterial.pinToEdges(of: root, orientation: .horizontal)
//        dividerMaterial.alignBelow(view: materialSection.root)

        // ==============================
        // Quality
        // ==============================

        let conditionTitle = ViewFactory.createTitle(R.string.localizable.create_ad_main_condition_title())
        root.addSubview(conditionTitle)
        conditionTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        conditionTitle.alignBelow(view: dividerBrand, withPadding: 32)

        let qualityView = QualitySelectionView(frame: .zero)
        qualityView.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(qualityView)
        // 4 = left, right + 2 for in between quality buttons
        let buttonHeight = (UIScreen.main.bounds.width - (2 * UIConstants.margin) - 2 * qualityView.buttonGap) / 3
        qualityView.setHeightAnchor(buttonHeight)
        qualityView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        qualityView.alignBelow(view: conditionTitle, withPadding: 16)
        viewModel.outputs.quality.compactMap { $0 }.bind(to: qualityView.inputs.quality).disposed(by: bag)
        qualityView.outputs.qualityRelay.compactMap { $0 }.bind(to: viewModel.inputs.quality).disposed(by: bag)

        let banner = ViewFactory.createTextBanner(title: "", icon: R.image.quality_tick_icon(), iconSize: 24)
        let bannerHeight = banner.root.setHeightAnchor(0)
        bannerHeight.isActive = false
        viewModel.outputs.quality
            .subscribe(onNext: { quality in
                bannerHeight.isActive = quality == nil
                if let quality = quality {
                    banner.text.text = quality.explanationText()
                }
            }).disposed(by: bag)
        root.addSubview(banner.root)
        banner.root.pinToEdges(of: root, orientation: .horizontal)
        banner.root.alignBelow(view: qualityView, withPadding: 16)

        // ==============================
        // Dimensions
        // ==============================

        let dimensionsTitle = ViewFactory.createTitle(R.string.localizable.create_ad_main_dimensions_title())
        dimensionsTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        root.addSubview(dimensionsTitle)
        dimensionsTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        dimensionsTitle.alignBelow(view: banner.root, withPadding: 16)

        let horizStack = ViewFactory.createHorizontalStack(spacing: 24)
        root.addSubview(horizStack)
        horizStack.alignBelow(view: dimensionsTitle, withPadding: 24)
        horizStack.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        horizStack.alignment = .center
        horizStack.distribution = .fillEqually

        let width = createDimensionTextfield(label: R.string.localizable.create_ad_main_dim_width(), placeholder: "0 cm")
        horizStack.addArrangedSubview(width.root)
        width.root.pinToEdges(of: horizStack, orientation: .vertical)
        viewModel.outputs.width.bind(to: width.textfield.rx.text).disposed(by: bag)
        width.textfield.rx.text.orEmpty.bind(to: viewModel.inputs.width).disposed(by: bag)

        let height = createDimensionTextfield(label: R.string.localizable.create_ad_main_dim_height(), placeholder: "0 cm")
        horizStack.addArrangedSubview(height.root)
        height.root.pinToEdges(of: horizStack, orientation: .vertical)
        viewModel.outputs.height.bind(to: height.textfield.rx.text).disposed(by: bag)
        height.textfield.rx.text.orEmpty.bind(to: viewModel.inputs.height).disposed(by: bag)

        let depth = createDimensionTextfield(label: R.string.localizable.create_ad_main_dim_depth(), placeholder: "0 cm")
        horizStack.addArrangedSubview(depth.root)
        depth.root.pinToEdges(of: horizStack, orientation: .vertical)
        viewModel.outputs.depth.bind(to: depth.textfield.rx.text).disposed(by: bag)
        depth.textfield.rx.text.orEmpty.bind(to: viewModel.inputs.depth).disposed(by: bag)

        // ==============================
        // Colors
        // ==============================

        let colorsTitle = ViewFactory.createTitle(R.string.localizable.create_ad_main_color_title())
        colorsTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        root.addSubview(colorsTitle)
        colorsTitle.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        colorsTitle.alignBelow(view: horizStack, withPadding: 16)

        setUpColors(root: root)
        colorsCollectionView.alignBelow(view: colorsTitle, withPadding: 16)

        let buttonText = nextButtonText(viewModel, R.string.localizable.createAdDetailsNextButton())
        let nextButton = ViewFactory.createPrimaryButton(text: buttonText)
        nextButton.analyticsKey = "NextStep"

        root.addSubview(nextButton)
        nextButton.alignBelow(view: colorsCollectionView, withPadding: 40)

        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.next()
        }.disposed(by: bag)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)

        addCloseButtonIfRequired(viewModel)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }

    struct TextSection {
        let root: UIView
        let left: UILabel
        let right: UILabel
        let disclosure: UIImageView
    }

    private func getTextSection(left: String, right: String) -> TextSection {
        let root = ViewFactory.createView()
        let title = ViewFactory.createLabel(text: left, font: .descriptionLabel)
        root.addSubview(title)
        title.center(withView: root, orientation: .vertical)
        title.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let rightArrow = ViewFactory.createImage(image: R.image.ic_arrow_right_gray())
        let rightLabel = ViewFactory.createLabel(text: right, font: .descriptionLabel)
        rightLabel.textColor = .silver
        root.addSubview(rightLabel)

        root.addSubview(rightArrow)
        rightLabel.textAlignment = .right
        rightArrow.setContentHuggingPriority(.required, for: .horizontal)
        rightArrow.setContentHuggingPriority(.required, for: .vertical)
        rightArrow.setContentCompressionResistancePriority(.required, for: .horizontal)
        rightArrow.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
        rightArrow.center(withView: root, orientation: .vertical)

        rightLabel.center(withView: root, orientation: .vertical)
        rightLabel.alignBefore(view: rightArrow, withPadding: -8)
        title.alignBefore(view: rightLabel, withPadding: -8)
        return TextSection(root: root, left: title, right: rightLabel, disclosure: rightArrow)
    }

    private struct DimensionView {
        let root: UIView
        let textfield: UITextField
    }

    private func createDimensionTextfield(label: String, placeholder: String) -> DimensionView {
        let root = ViewFactory.createView()
        root.layer.borderColor = UIColor.smoke.cgColor
        root.layer.borderWidth = 1.0
        root.layer.cornerRadius = 4.0

        root.setAspect(1)
        let textfield = UITextField()
        textfield.keyboardType = .numberPad
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = placeholder
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = .black
        textfield.textAlignment = .center
        root.addSubview(textfield)
        textfield.pinToEdges(of: root, orientation: .horizontal, padding: 8)
        textfield.verticalPin(to: root, orientation: .top, padding: 18)

        let label = ViewFactory.createLabel(text: label, font: .label)
        label.textColor = .silver
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        root.addSubview(label)
        label.pinToEdges(of: root, orientation: .horizontal, padding: 8)
        label.verticalPin(to: root, orientation: .bottom, padding: -18)

        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(onNext: { _ in
            textfield.becomeFirstResponder()
        }).disposed(by: bag)
        root.addGestureRecognizer(tap)

        return DimensionView(root: root, textfield: textfield)
    }

    private func getBrandSection() -> TextSection {
        let brandSection = getTextSection(left: "", right: "")
        let brandTap = UITapGestureRecognizer()
        brandTap.rx.event.bind(onNext: { [weak self] _ in
            self?.viewModel.selectBrandOrArtist()
        }).disposed(by: bag)
        brandSection.root.addGestureRecognizer(brandTap)
        brandSection.root.setHeightAnchor(44)
        viewModel.outputs.brandTitle.bind(to: brandSection.left.rx.text).disposed(by: bag)
        viewModel.outputs.brandValue.bind(to: brandSection.right.rx.text).disposed(by: bag)
        return brandSection
    }

    private func getMaterialSection() -> TextSection {
        let materialSection = getTextSection(left: R.string.localizable.create_ad_main_material_title(), right: "")
        let materialTap = UITapGestureRecognizer()
        materialTap.rx.event.bind(onNext: { [weak self] _ in
            self?.viewModel.selectMaterial()
        }).disposed(by: bag)
        materialSection.root.addGestureRecognizer(materialTap)
        materialSection.root.setHeightAnchor(44)
        viewModel.outputs.materialTitle.bind(to: materialSection.right.rx.text).disposed(by: bag)
        return materialSection
    }

    private func setUpColors(root: UIView) {
        colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.backgroundColor = .clear
        colorsCollectionView.isScrollEnabled = false

        colorsCollectionView.delegate = self
        root.addSubview(colorsCollectionView)
        let colorsHeight = colorsCollectionView.setHeightAnchor(0)
        colorsCollectionView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        colorsCollectionView.register(UINib(nibName: ColorCell.nibName, bundle: nil), forCellWithReuseIdentifier: ColorCell.identifier)
        viewModel.outputs.colors.bind(to: colorsCollectionView.rx.items(cellIdentifier: ColorCell.identifier, cellType: ColorCell.self)) { _, viewModel, cell in
            cell.setUp(with: viewModel)
        }.disposed(by: bag)

        colorsCollectionView.register(UINib(nibName: ColorCell.nibName, bundle: nil), forCellWithReuseIdentifier: ColorCell.identifier)

        viewModel.outputs.colors.subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            let numberOfRows = (CGFloat(list.count) / 7).rounded(.up)
            colorsHeight.constant = numberOfRows * 40.0 + 8.0 * (numberOfRows - 1)
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }, onError: { [weak self] error in
            self?.showError(error)
        }).disposed(by: bag)

        Observable
            .zip(colorsCollectionView.rx.itemSelected, colorsCollectionView.rx.modelSelected(ColorViewModel.self))
            .bind { [weak self] indexPath, model in
                guard let self = self else { return }
                model.selected = !model.selected
                let cell = self.colorsCollectionView.cellForItem(at: indexPath) as! ColorCell
                cell.state = model.selected ? .selected : .normal
                self.viewModel.colorSelected(vm: model)
            }.disposed(by: bag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateAdDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: 40.0, height: 40.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }
}
