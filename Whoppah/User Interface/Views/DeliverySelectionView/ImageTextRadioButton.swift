//
//  ImageTextRadioButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/10/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

class ImageTextRadioButton: UIControl {
    // MARK: - Properties

    private var nameLabel: UILabel!
    private var sizeLabel: UILabel!
    private var radio: RadioButton!
    private var imageView: UIImageView!
    var otherButtons = [ImageTextRadioButton]()

    var name: String = "" {
        didSet {
            nameLabel.text = name
            nameLabel.sizeToFit()
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var size: String = "" {
        didSet {
            sizeLabel.text = size
            sizeLabel.isHidden = size.isEmpty
            sizeLabel.sizeToFit()
        }
    }

    override var isSelected: Bool {
        didSet {
            radio.isSelected = isSelected
            if isSelected {
                for button in otherButtons where button != self {
                    button.isSelected = false
                }
            }
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

    // MARK: - Common Init

    private func commonInit() {
        layer.borderColor = UIColor.shinyBlue.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0

        let imageBackground = ViewFactory.createView(skeletonable: true)
        addSubview(imageBackground)
        imageBackground.horizontalPin(to: self, orientation: .leading)
        imageBackground.setEqualsSize(toView: self, orientation: .vertical)
        imageBackground.setAspect(1)
        imageBackground.backgroundColor = .shinyBlue
        imageBackground.layer.cornerRadius = 4.0
        imageBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        let imageView = ViewFactory.createImage(image: nil, skeletonable: true)
        imageBackground.addSubview(imageView)
        imageView.center(withView: imageBackground, orientation: .vertical)
        imageView.center(withView: imageBackground, orientation: .horizontal)
        self.imageView = imageView

        let stackView = ViewFactory.createVerticalStack(skeletonable: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.pinToEdges(of: self, orientation: .vertical, padding: 8)
        stackView.alignAfter(view: imageBackground, withPadding: UIConstants.margin)

        nameLabel = ViewFactory.createLabel(text: "", font: .descriptionLabel, skeletonable: true)
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        stackView.addArrangedSubview(nameLabel)
        nameLabel.pinToEdges(of: stackView, orientation: .horizontal)

        sizeLabel = ViewFactory.createLabel(text: "", font: .descriptionText, skeletonable: true)
        sizeLabel.numberOfLines = 2
        sizeLabel.textColor = .steel
        sizeLabel.adjustsFontSizeToFitWidth = true
        stackView.addArrangedSubview(sizeLabel)
        sizeLabel.pinToEdges(of: stackView, orientation: .horizontal)

        radio = ViewFactory.createRadioButton(width: 24, skeletonable: true)
        addSubview(radio)
        radio.isUserInteractionEnabled = false
        radio.center(withView: self, orientation: .vertical)
        radio.horizontalPin(to: self, orientation: .trailing, padding: -UIConstants.margin)
        stackView.alignBefore(view: radio, withPadding: -8)
    }
}
