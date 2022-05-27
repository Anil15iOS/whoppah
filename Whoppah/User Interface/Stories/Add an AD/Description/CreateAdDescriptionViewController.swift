//
//  CreateAdDescriptionViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CreateAdDescriptionViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdDescriptionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        analyticsKey = "AdCreation_DescriptionSection"
        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), transparent: false)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(viewModel.title)
        root.addSubview(title)
        title.textColor = .black
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let titleTF = ViewFactory.createTextField(placeholder: R.string.localizable.create_ad_main_title())
        viewModel.outputs.title.subscribe(onNext: { text in
            titleTF.text = text.title
            titleTF.errorMessage = text.error
            if text.error != nil {
                scrollView.scroll.setContentOffset(CGPoint(x: 0.0, y: titleTF.frame.origin.y - 16.0), animated: true)
            }
        }).disposed(by: bag)
        root.addSubview(titleTF)
        titleTF.contentHeight = UIConstants.textfieldHeight
        titleTF.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        titleTF.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        titleTF.rx.text.orEmpty.bind(to: viewModel.inputs.title).disposed(by: bag)

        let titleCountLabel = ViewFactory.createLabel(text: "", font: .descriptionText)
        titleCountLabel.textColor = .silver
        root.addSubview(titleCountLabel)
        titleCountLabel.horizontalPin(to: titleTF, orientation: .trailing)
        titleCountLabel.alignBelow(view: titleTF, withPadding: 4)
        viewModel.outputs.titleLimitsText.bind(to: titleCountLabel.rx.text).disposed(by: bag)

        let descriptionTextView = ViewFactory.createTextView(placeholder: R.string.localizable.create_ad_main_description())
        root.addSubview(descriptionTextView)
        descriptionTextView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        descriptionTextView.alignBelow(view: titleTF, withPadding: 24)
        descriptionTextView.setHeightAnchor(190)

        viewModel.outputs.description.subscribe(onNext: { text in
            descriptionTextView.textview.text = text.title
            descriptionTextView.errorMessage = text.error
            if text.error != nil {
                scrollView.scroll.setContentOffset(CGPoint(x: 0.0, y: descriptionTextView.frame.origin.y - 16.0), animated: true)
            }
        }).disposed(by: bag)

        descriptionTextView.textview.rx.text.orEmpty.bind(to: viewModel.inputs.description).disposed(by: bag)
        // Scroll views conflict with each other, scrolling
        descriptionTextView.textview.rx.willBeginDragging.map { false }.bind(to: scrollView.scroll.rx.isScrollEnabled).disposed(by: bag)
        descriptionTextView.textview.rx.willEndDragging.map { _ in true }.bind(to: scrollView.scroll.rx.isScrollEnabled).disposed(by: bag)

        let descriptionCountLabel = ViewFactory.createLabel(text: "", font: .descriptionText)
        descriptionCountLabel.textColor = .silver
        root.addSubview(descriptionCountLabel)
        descriptionCountLabel.horizontalPin(to: descriptionTextView, orientation: .trailing)
        descriptionCountLabel.alignBelow(view: descriptionTextView, withPadding: 4)
        viewModel.outputs.descriptionLimitsText.bind(to: descriptionCountLabel.rx.text).disposed(by: bag)

        let bulletsView = ViewFactory.getBulletsView(title: R.string.localizable.createAdDescriptionBulletTitle(),
                                                     bullets: viewModel.getBulletText())
        let bulletTitle = bulletsView.0
        let bullets = bulletsView.1

        root.addSubview(bulletTitle)
        bulletTitle.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        bulletTitle.alignBelow(view: descriptionTextView, withPadding: 24)

        root.addSubview(bullets)
        bullets.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        bullets.alignBelow(view: bulletTitle, withPadding: 6)

        let buttonText = nextButtonText(viewModel, R.string.localizable.createAdDescriptionNextButton())
        let nextButton = ViewFactory.createPrimaryButton(text: buttonText)
        nextButton.analyticsKey = "Next"

        root.addSubview(nextButton)
        nextButton.alignBelow(view: bullets, withPadding: 40)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in self?.viewModel.next() }.disposed(by: bag)
        viewModel.outputs.nextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: bag)
        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)

        addCloseButtonIfRequired(viewModel)

        if let right = navigationItem.rightBarButtonItem {
            titleTF.rx.text.orEmpty.map { !$0.isEmpty }.bind(to: right.rx.isEnabled).disposed(by: bag)
        }
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }
}
