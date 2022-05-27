//
//  ChatCellDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 24/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class ChatCellDialog: UIViewController {
    private let bag = DisposeBag()
    private let color: UIColor
    private let icon: UIImage?
    var buttonContainer: UIView!
    private let dialogDescription: String
    private let dismiss: (UIViewController) -> Void

    init(color: UIColor, icon: UIImage?, title: String, description: String, dismiss: @escaping ((UIViewController) -> Void)) {
        self.color = color
        self.icon = icon
        dialogDescription = description
        self.dismiss = dismiss
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        background.backgroundColor = .white
        background.layer.cornerRadius = 6.0
        background.clipsToBounds = true
        background.layer.borderColor = color.cgColor
        background.layer.borderWidth = 1
        background.horizontalPin(to: view, orientation: .leading)
        background.horizontalPin(to: view, orientation: .trailing, padding: -UIConstants.margin)
        background.pinToEdges(of: view, orientation: .vertical)

        let closeButton = ViewFactory.createLargeButton(image: R.image.ic_close()!)
        background.addSubview(closeButton)
        closeButton.horizontalPin(to: background, orientation: .leading, padding: -6)
        closeButton.verticalPin(to: background, orientation: .top, padding: -6)
        closeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dismiss(self)
        }.disposed(by: bag)

        let title = ViewFactory.createTitle(self.title ?? "", font: .descriptionLabel)
        title.textColor = color
        background.addSubview(title)
        title.textAlignment = .center

        title.verticalPin(to: background, orientation: .top, padding: 12)

        if let icon = self.icon {
            let imageView = ViewFactory.createImage(image: icon)
            background.addSubview(imageView)
            title.sizeToFit()
            title.center(withView: background, orientation: .horizontal, padding: 8 + imageView.frame.width)
            imageView.alignBefore(view: title, withPadding: -8)
            imageView.center(withView: title, orientation: .vertical)
        } else {
            title.center(withView: background, orientation: .horizontal)
        }

        let description = ViewFactory.createLabel(text: "", lines: 0, alignment: .center, font: .descriptionText)
        background.addSubview(description)
        if dialogDescription.containsHtml() {
            description.setHtml(dialogDescription)
        } else {
            description.text = dialogDescription
        }
        description.pinToEdges(of: background, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: 0)

        buttonContainer = ViewFactory.createView()
        background.addSubview(buttonContainer)
        buttonContainer.pinToEdges(of: background, orientation: .horizontal, padding: UIConstants.margin)
        buttonContainer.alignBelow(view: description, withPadding: 5)

        background.verticalPin(to: buttonContainer, orientation: .bottom, padding: UIConstants.margin)
    }
}
