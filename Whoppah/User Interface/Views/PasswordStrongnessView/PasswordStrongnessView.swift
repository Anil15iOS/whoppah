//
//  PasswordStrongnessView.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/27/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore

class PasswordStrongnessView: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var lenghtIndicatorView: UIImageView!
    @IBOutlet var digitsIndicatorView: UIImageView!
    @IBOutlet var capitalLetterIndicatorView: UIImageView!
    @IBOutlet var lowerCaseLetterIndicatiorView: UIImageView!
    @IBOutlet var lenghtLabel: UILabel!
    @IBOutlet var digitsLabel: UILabel!
    @IBOutlet var capitalLetterLabel: UILabel!
    @IBOutlet var lowerCaseLetterLabel: UILabel!

    // MARK: - Properties

    var text: String = "" {
        didSet { updateIndicators() }
    }

    var validLenght: Bool = false {
        didSet {
            _isValid.accept(isValid)
        }
    }

    var hasDigit: Bool = false { didSet { _isValid.accept(isValid) } }
    var hasCapitalLetter: Bool = false { didSet { _isValid.accept(isValid) } }
    var hasLowerCaseLetter: Bool = false { didSet { _isValid.accept(isValid) } }
    var isValid: Bool {
        validLenght && hasDigit && hasCapitalLetter && hasLowerCaseLetter
    }

    private var _isValid = PublishRelay<Bool>()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("PasswordStrongnessView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        updateLabels()
        updateIndicators()
    }

    // MARK: - Private

    private func updateLabels() {
        lenghtLabel.text = R.string.localizable.common_password_rule1()
        digitsLabel.text = R.string.localizable.common_password_rule2()
        capitalLetterLabel.text = R.string.localizable.common_password_rule3()
        lowerCaseLetterLabel.text = R.string.localizable.common_password_rule4()
    }

    private func updateIndicators(_ showError: Bool = false) {
        let passwordResult = Auth.validatePassword(text)

        let errorColor = showError ? R.color.redInvalidLight() : UIColor.silver
        hasCapitalLetter = passwordResult.hasCapitalLetter
        capitalLetterIndicatorView.image = hasCapitalLetter ? R.image.greenTick() : R.image.grayTick()
        capitalLetterLabel.textColor = hasCapitalLetter ? UIColor.space : errorColor

        hasLowerCaseLetter = passwordResult.hasLowerLetter
        lowerCaseLetterIndicatiorView.image = hasLowerCaseLetter ? R.image.greenTick() : R.image.grayTick()
        lowerCaseLetterLabel.textColor = hasLowerCaseLetter ? UIColor.space : errorColor

        hasDigit = passwordResult.hasNumber
        digitsIndicatorView.image = hasDigit ? R.image.greenTick() : R.image.grayTick()
        digitsLabel.textColor = hasDigit ? UIColor.space : errorColor

        validLenght = passwordResult.validLength
        lenghtIndicatorView.image = validLenght ? R.image.greenTick() : R.image.grayTick()
        lenghtLabel.textColor = validLenght ? UIColor.space : errorColor
    }

    public func validate() -> Bool {
        updateIndicators(true)
        return isValid
    }
}
