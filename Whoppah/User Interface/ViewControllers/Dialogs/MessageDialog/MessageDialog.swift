//
//  MessageDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/2/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol MessageDialogDelegate: AnyObject {
    func messageDialogDidPresented(_ viewController: MessageDialog)
    func messageDialogDidDismissed(_ viewController: MessageDialog)
}

class MessageDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var closeButton: UIButton!

    // MARK: - Properties

    weak var delegate: MessageDialogDelegate?
    private var titleText: String?
    private var messageText: String?
    private var image: UIImage?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText?.uppercased()
        if let text = messageText, text.containsHtml() {
            messageLabel.setHtml(text, align: .center)
        } else {
            messageLabel.text = messageText
        }
        imageView.image = image
        imageContainer.isVisible = image != nil

        delegate?.messageDialogDidPresented(self)
        onComplete = { [weak self] in
            guard let self = self else { return }
            self.delegate?.messageDialogDidDismissed(self)
        }
    }

    // MARK: - Initialization

    init(title: String?, message: String?, image: UIImage? = nil) {
        titleText = title
        messageText = message
        self.image = image

        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
