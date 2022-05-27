//
//  AccountChooserViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 20/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import WhoppahCore
import WhoppahDataStore

class AccountTypeChooserViewController: UIViewController {
    private let bag = DisposeBag()
    var viewModel: RegistrationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.authAccountTypeChooserScreenTitle(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authAccountTypeChooserTitle())
        root.addSubview(title)

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let dividerPerson = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(dividerPerson)
        dividerPerson.setEqualsSize(toView: view, orientation: .horizontal)
        dividerPerson.center(withView: view, orientation: .horizontal)
        dividerPerson.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)

        let person = getRow(type: .person) { [weak self] in
            self?.onRowTapped(type: .individual)
        }
        root.addSubview(person)

        person.setHeightAnchor(88)
        person.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        person.alignBelow(view: dividerPerson)

        let dividerMiddle = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(dividerMiddle)
        dividerMiddle.setEqualsSize(toView: view, orientation: .horizontal)
        dividerMiddle.center(withView: view, orientation: .horizontal)
        dividerMiddle.alignBelow(view: person)

        let business = getRow(type: .business) { [weak self] in
            self?.onRowTapped(type: .business)
        }

        root.addSubview(business)

        business.setHeightAnchor(88)
        business.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        business.alignBelow(view: dividerMiddle)

        let dividerBusiness = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(dividerBusiness)
        dividerBusiness.setEqualsSize(toView: view, orientation: .horizontal)
        dividerBusiness.center(withView: view, orientation: .horizontal)
        dividerBusiness.alignBelow(view: business)

        root.verticalPin(to: dividerBusiness, orientation: .bottom, padding: UIConstants.margin)

        if navigationController?.viewControllers.count == 1 {
            addCloseButton(image: R.image.ic_close()).rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.dismiss()
            }.disposed(by: bag)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.step = .accountChooser
    }

    private enum AccountType {
        case person
        case business
    }

    private func getRow(type: AccountType, onTap: @escaping (() -> Void)) -> UIView {
        var icon = R.image.authPersonIcon()
        var titleText = R.string.localizable.authAccountTypeChooserPersonTitle()
        var subtitleText = R.string.localizable.authAccountTypeChooserPersonSubtitle()
        if type == .business {
            icon = R.image.authBusinessIcon()
            titleText = R.string.localizable.authAccountTypeChooserBusinessTitle()
            subtitleText = R.string.localizable.authAccountTypeChooserBusinessSubtitle()
        }

        let image = ViewFactory.createImage(image: icon, width: 48, aspect: 1.0)
        let stack = ViewFactory.createHorizontalStack(spacing: 16)
        stack.alignment = .center
        stack.addArrangedSubview(image)

        let vertStack = ViewFactory.createVerticalStack(spacing: 8)
        stack.addArrangedSubview(vertStack)

        let right = ViewFactory.createImage(image: R.image.authRightIcon(), width: 13, aspect: 1.61)
        stack.addArrangedSubview(right)

        vertStack.distribution = .equalSpacing
        let title = ViewFactory.createLabel(text: titleText, font: .descriptionLabel)
        let subtitle = ViewFactory.createLabel(text: subtitleText, lines: 0, font: .smallText)
        vertStack.addArrangedSubview(title)
        vertStack.addArrangedSubview(subtitle)
        title.pinToEdges(of: vertStack, orientation: .horizontal)
        subtitle.pinToEdges(of: vertStack, orientation: .horizontal)

        let businessTap = UITapGestureRecognizer()
        businessTap.rx.event.bind(onNext: { _ in
            onTap()
        }).disposed(by: bag)
        stack.addGestureRecognizer(businessTap)
        return stack
    }

    private func onRowTapped(type: GraphQL.MerchantType) {
        viewModel.merchantType = type
        viewModel.next()
    }
}
