//
//  CheckBox.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

@objc protocol CheckBoxDelegate: AnyObject {
    func checkBoxDidChangeState(_ checkBox: CheckBox)
}

@IBDesignable
class CheckBox: UIControl {
    // MARK: - Properties

    @IBOutlet weak var delegate: CheckBoxDelegate?
    private let checkIcon = UIImageView(image: R.image.check())
    private var background: UIView!
    @IBOutlet var associatedTapView: UIView? {
        didSet {
            if let tapView = associatedTapView {
                tapView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
                tapView.addGestureRecognizer(tap)
            }
        }
    }

    private let bag = DisposeBag()
    var selectedSubject = PublishSubject<Bool>()
    var animate: Bool = true

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override var bounds: CGRect {
        didSet {
            background.frame = bounds
            checkIcon.frame = bounds
        }
    }

    var boxColor: UIColor? {
        didSet {
            layer.borderColor = boxColor?.cgColor ?? UIColor.silver.cgColor
        }
    }

    // MARK: - Common Init

    private func commonInit() {
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        boxColor = nil

        background = UIView()
        background.frame = bounds
        background.clipsToBounds = true
        background.alpha = 0.0
        background.layer.cornerRadius = 2.0
        background.backgroundColor = .shinyBlue
        addSubview(background)

        checkIcon.frame = bounds
        checkIcon.contentMode = .center
        addSubview(checkIcon)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)

        selectedSubject.subscribe(onNext: { [weak self] selected in
            guard let self = self else { return }
            self.isSelected = selected
        }).disposed(by: bag)
    }

    // MARK: - Override

    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                check()
            } else {
                uncheck()
            }
        }
    }

    // MARK: - Private

    private func check() {
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.layer.borderWidth = 0.0
                self.background.alpha = 1.0
            }
        } else {
            layer.borderWidth = 0.0
            background.alpha = 1.0
        }
    }

    private func uncheck() {
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.layer.borderWidth = 1.0
                self.background.alpha = 0.0
            }
        } else {
            layer.borderWidth = 1.0
            background.alpha = 0.0
        }
    }

    // MARK: - Actions

    @objc func tapAction(_: UITapGestureRecognizer) {
        isSelected = !isSelected
        selectedSubject.onNext(isSelected)
        delegate?.checkBoxDidChangeState(self)
    }
}
