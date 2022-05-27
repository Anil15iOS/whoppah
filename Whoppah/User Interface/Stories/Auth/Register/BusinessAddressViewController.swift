//
//  BusinessAddressViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 03/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

class BusinessAddresssViewController: UIViewController {
    var viewModel: RegistrationViewModel!

    private var validators = [ValidatorComponent]()
    private let bag = DisposeBag()
    typealias CompletionBlock = (() -> Void)
    var onCompletion: CompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.authSignUp5ScreenTitle().capitalizingFirstLetter(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authSignUp5Title())
        root.addSubview(title)

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let country = ViewFactory.createCountryTextField(placeholder: R.string.localizable.add_address_country_placeholder())
        viewModel.outputs.country
            .map { $0.title }
            .bind(to: country.rx.text).disposed(by: bag)
        root.addSubview(country)
        country.alignBelow(view: title, withPadding: 16)
        country.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        country.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        country.picker.rx.itemSelected
            .map { Country.allCases[$0.0] }
            .bind(to: viewModel.inputs.country).disposed(by: bag)

        country.picker.rx.itemSelected
            .map { Country.allCases[$0.0].title }
            .bind(to: country.rx.text).disposed(by: bag)

        let street = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_street_placeholder())
        street.rx.text.orEmpty.bind(to: viewModel.inputs.line1).disposed(by: bag)
        viewModel.outputs.line1.bind(to: street.rx.text).disposed(by: bag)
        street.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        street.textContentType = .streetAddressLine1
        root.addSubview(street)
        street.contentHeight = UIConstants.textfieldHeight
        street.alignBelow(view: country, withPadding: 16)
        street.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(street,
                                                  errorMessage: R.string.localizable.commonMissingAddressStreet(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let line2 = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_line2_placeholder())
        line2.rx.text.orEmpty.bind(to: viewModel.inputs.line2).disposed(by: bag)
        viewModel.outputs.line2.bind(to: line2.rx.text).disposed(by: bag)
        line2.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        line2.textContentType = .streetAddressLine2
        root.addSubview(line2)
        line2.contentHeight = UIConstants.textfieldHeight
        line2.alignBelow(view: street, withPadding: 16)
        line2.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        let postcode = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_postcode_placeholder())
        postcode.rx.text.orEmpty.bind(to: viewModel.inputs.postcode).disposed(by: bag)
        viewModel.outputs.postcode.bind(to: postcode.rx.text).disposed(by: bag)
        postcode.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        postcode.textContentType = .postalCode
        root.addSubview(postcode)
        postcode.contentHeight = UIConstants.textfieldHeight
        postcode.alignBelow(view: line2, withPadding: 16)
        postcode.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(postcode,
                                                  errorMessage: R.string.localizable.commonInvalidAddressPostcode(),
                                                  validator: { textfield -> Bool in
                                                    !textfield.text!.isEmpty
        }))

        let city = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_city_placeholder())
        city.rx.text.orEmpty.bind(to: viewModel.inputs.city).disposed(by: bag)
        viewModel.outputs.city.bind(to: city.rx.text).disposed(by: bag)
        city.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        city.textContentType = .addressCity
        root.addSubview(city)
        city.contentHeight = UIConstants.textfieldHeight
        city.alignBelow(view: postcode, withPadding: 16)
        city.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(city,
                                                  errorMessage: R.string.localizable.commonMissingAddressCity(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let step = StepView.createStepView(forStep: viewModel.currentStep, withTotal: viewModel.numberOfSteps)
        root.addSubview(step)
        step.alignBelow(view: city, withPadding: 24)
        step.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)

        let nextButton = ViewFactory.createPrimaryButton(text: viewModel.actionButtonText)
        viewModel.outputs.loading.bind(to: nextButton.rx.isAnimating).disposed(by: bag)
        viewModel.outputs.loading.map { !$0 }.bind(to: nextButton.rx.isEnabled).disposed(by: bag)
        root.addSubview(nextButton)
        nextButton.alignBelow(view: step, withPadding: 8)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.validateData() else { return }
            self.viewModel.next()
        }.disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: 16)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.step = .merchantAddress
    }

    private func validateData() -> Bool {
        var isValid = true
        for validator in validators {
            isValid = validator.validate() && isValid
        }
        return isValid
    }
}
