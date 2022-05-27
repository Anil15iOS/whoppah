//
//  WhoppahInputView.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/29/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import RxSwift
import UIKit

open class WPInputView: MSGInputView {
    
    enum Button {
        case bidding
        case delivery
    }
    
    var didTapButton: ((Button) -> Void)?
    
    // MARK: - IBOutlets

    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var messagePlaceholderLabel: UILabel!
    @IBOutlet var buttonStackView: UIStackView!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var customSendButton: UIButton!

    private let bag = DisposeBag()

    // MARK: -

    open override class var nib: UINib? {
        UINib(nibName: "WPInputView", bundle: nil)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        setUpTextView()
        customSendButton.isHidden = true

        heightConstaint?.constant = 110.0
        minHeight = 119.0
        maxHeight = 119.0
    }

    private func setUpTextView() {
        sendButton.tintColor = .white
        sendButton.backgroundColor = tintColor

        messageTextView.tintColor = tintColor
        messageTextView.layer.cornerRadius = 20
        messageTextView.layer.borderColor = UIColor.silver.cgColor
        messageTextView.layer.borderWidth = 1.0
        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 14, bottom: 0, right: 36)

        messageTextView.rx.didBeginEditing.map { true }.bind(to: messagePlaceholderLabel.rx.isHidden).disposed(by: bag)
        Observable.combineLatest(messageTextView.rx.text.orEmpty, messageTextView.rx.didEndEditing)
            .map { [weak self] in !$0.0.isEmpty || self?.messageTextView.isFirstResponder == true }
            .bind(to: messagePlaceholderLabel.rx.isHidden).disposed(by: bag)
        messageTextView.rx.text.orEmpty.map { !$0.isEmpty }.bind(to: customSendButton.rx.isVisible).disposed(by: bag)
        messageTextView.rx.text.orEmpty.map { $0.isEmpty }.bind(to: cameraButton.rx.isVisible).disposed(by: bag)
        messageTextView.rx.text.orEmpty.map { $0.isEmpty }.bind(to: galleryButton.rx.isVisible).disposed(by: bag)
        messageTextView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.updateTextviewHeight()

            let isEmpty = text.isEmpty
            if isEmpty != self.cameraButton.isVisible {
                self.buttonStackView.subviews.forEach { $0.isVisible = isEmpty }
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                }
            }
        }).disposed(by: bag)
    }

    // MARK: - IBActions

    @IBAction func customSendAction(_: UIButton) {
        sendActions(for: .primaryActionTriggered)
        messageTextView.text = ""
        updateTextviewHeight()
    }
    
    @IBAction func deliveryAction(_ sender: UIButton) {
        didTapButton?(.delivery)
    }
    
    @IBAction func howItWorkAction(_ sender: UIButton) {
        didTapButton?(.bidding)
    }
    
    private func updateTextviewHeight() {
        let size = messageTextView.sizeThatFits(CGSize(width: messageTextView.bounds.size.width, height: .infinity))

        let textviewMinHeight: CGFloat = 39
        guard size.height >= textviewMinHeight else {
            heightConstaint?.constant = minHeight
            return
        }
        let diff = size.height - textviewMinHeight
        heightConstaint?.constant = minHeight + diff
    }
}
