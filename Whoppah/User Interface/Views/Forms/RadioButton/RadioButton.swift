//
//  RadioButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol RadioButtonDelegate: AnyObject {
    func radioButtonDidChangeState(_ radioButton: RadioButton)
}

@IBDesignable
class RadioButton: UIControl {
    // MARK: - Properties

    weak var delegate: RadioButtonDelegate?
    private var bullet: UIView!
    private var backgroundView: UIView!
    var groupButtons = [RadioButton]()
    private let bag = DisposeBag()
    var selectedSubject = PublishSubject<Bool>()
    var animate: Bool = true

    @IBOutlet var associatedTapView: UIView? {
        didSet {
            if let tapView = associatedTapView {
                tapView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
                tapView.addGestureRecognizer(tap)
            }
        }
    }

    var checkedColor = UIColor.shinyBlue {
        didSet {
            if isSelected {
                self.backgroundView.backgroundColor = checkedColor
            }
        }
    }

    override var bounds: CGRect {
        didSet {
            backgroundView.frame = bounds
            backgroundView.layer.cornerRadius = bounds.height / 2
            layer.cornerRadius = bounds.height / 2
            bullet.frame = CGRect(x: bounds.width / 2 - 3.0, y: bounds.height / 2 - 3.0, width: 6.0, height: 6.0)
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Common Init

    private func commonInit() {
        backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = bounds.height / 2
        addSubview(backgroundView)

        layer.cornerRadius = bounds.height / 2
        layer.borderColor = UIColor.silver.cgColor
        layer.borderWidth = 1.0

        bullet = UIView()
        bullet.frame = CGRect(x: bounds.width / 2 - 3.0, y: bounds.height / 2 - 3.0, width: 6.0, height: 6.0)
        bullet.backgroundColor = .white
        bullet.layer.cornerRadius = 3.0
        addSubview(bullet)

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
                self.backgroundView.backgroundColor = self.checkedColor
            }
        } else {
            layer.borderWidth = 0.0
            backgroundView.backgroundColor = checkedColor
        }
    }

    private func uncheck() {
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.layer.borderWidth = 1.0
                self.backgroundView.backgroundColor = .white
            }
        } else {
            layer.borderWidth = 1.0
            backgroundView.backgroundColor = .white
        }
    }

    // MARK: - Actions

    @objc func tapAction(_: UITapGestureRecognizer) {
        isSelected = true
        selectedSubject.onNext(isSelected)

        for button in groupButtons {
            guard button != self else { continue }
            button.isSelected = false
            button.selectedSubject.onNext(false)
        }

        delegate?.radioButtonDidChangeState(self)
    }
}
