//
//  YesNoDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 02/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class YesNoDialog: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var closeButton: UIButton!

    private var titleText: String?
    private var messageText: String?
    var yesText: String? {
        didSet {
            if isViewLoaded, yesText != nil {
                yesButton.setTitle(yesText!, for: .normal)
            }
        }
    }

    var noText: String? {
        didSet {
            if self.isViewLoaded, noText != nil {
                noButton.setTitle(noText!, for: .normal)
            }
        }
    }

    // MARK: - Properties

    weak var delegate: MessageDialogDelegate?

    enum ButtonType {
        case yes
        case no
        case cancel
    }

    typealias ButtonClickedCallback = ((ButtonType) -> Void)
    var onButtonPressed: ButtonClickedCallback?

    var allowsCloseButton: Bool = true {
        didSet {
            if let close = closeButton {
                close.isHidden = !allowsCloseButton
            }
        }
    }

    var closeButtonAction = ButtonType.no

    static func create(withMessage message: String, andTitle title: String, onButtonPressed: ButtonClickedCallback? = nil) -> YesNoDialog {
        let dialog = YesNoDialog()
        dialog.messageText = message
        dialog.titleText = title
        dialog.onButtonPressed = onButtonPressed
        return dialog
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        messageLabel.text = messageText
        if let yes = yesButton as? PrimaryLargeButton {
            yes.style = .shinyBlue
        }
        if let no = noButton as? SecondaryLargeButton {
            no.buttonColor = .shinyBlue
        }
        if let text = yesText {
            yesButton.setTitle(text, for: .normal)
        }
        if let text = noText {
            noButton.setTitle(text, for: .normal)
        }

        closeButton.isHidden = !allowsCloseButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if allowsCloseButton {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            view.addGestureRecognizer(tap)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let gesture = view.gestureRecognizers?.first {
            view.removeGestureRecognizer(gesture)
        }
    }

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
        onButtonPressed?(closeButtonAction)
    }

    @objc func tapAction(_: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
        onButtonPressed?(closeButtonAction)
    }

    @IBAction func yesPressed(_: UIButton) {
        dismiss(animated: true, completion: nil)
        onButtonPressed?(.yes)
    }

    @IBAction func noPressed(_: UIButton) {
        dismiss(animated: true, completion: nil)
        onButtonPressed?(.no)
    }
}
