//
//  ChatsEmptyView.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

protocol ChatsEmptyViewDelegate: AnyObject {
    func sendQuestion(withText text: String, completion: @escaping (() -> Void))
}

class ChatsEmptyView: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var questionContainerView: UIView!
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var questionSendButton: UIButton!
    @IBOutlet var questionTextViewHeight: NSLayoutConstraint!
    @IBOutlet var questionPlaceholderLabel: UILabel!

    private let bag = DisposeBag()

    weak var delegate: ChatsEmptyViewDelegate?

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
        Bundle.main.loadNibNamed("ChatsEmptyView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        setUpTextField()
    }
}

// MARK: Empty view

extension ChatsEmptyView {
    private func setUpTextField() {
        questionContainerView.layer.cornerRadius = questionContainerView.bounds.height / 2
        questionContainerView.layer.borderColor = UIColor.smoke.cgColor
        questionContainerView.layer.borderWidth = 1.0

        questionTextView.delegate = self
        questionTextView.rx.didBeginEditing.map { true }.bind(to: questionPlaceholderLabel.rx.isHidden).disposed(by: bag)
        questionTextView.rx.text.orEmpty.map { [weak self] in !$0.isEmpty || self?.questionTextView.isFirstResponder == true }.bind(to: questionPlaceholderLabel.rx.isHidden).disposed(by: bag)
        questionTextView.rx.text.orEmpty.map { !$0.isEmpty }.bind(to: questionSendButton.rx.isEnabled).disposed(by: bag)
    }

    @objc func sendMessageAction(_: Any) {
        guard let text = questionTextView.text, !text.isEmpty else { return }
        delegate?.sendQuestion(withText: text) { [weak self] in
            guard let self = self else { return }
            self.questionTextView.text = nil
            self.adjustTextViewHeight()
        }
    }
}

extension ChatsEmptyView: UITextViewDelegate {
    func adjustTextViewHeight() {
        let fixedWidth: CGFloat = bounds.size.width - 41
        let newSize = questionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        questionTextViewHeight.constant = max(newSize.height, 44)
        questionTextView.bounds = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        layoutIfNeeded()
    }

    func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText _: String) -> Bool {
        adjustTextViewHeight()
        return true
    }
}
