//
//  QualityButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/8/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

class QualityButton: UIControl {
    private var qualityView: UIImageView!
    private var nameLabel: UILabel!

    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }

    var quality: GraphQL.ProductQuality = .good {
        didSet {
            updateQualityIcon()
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .shinyBlue
                layer.borderWidth = 0.0
                nameLabel.textColor = .white
            } else {
                backgroundColor = .white
                layer.borderWidth = 1.0
                nameLabel.textColor = .silver
            }
            updateQualityIcon()
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
        layer.borderColor = UIColor.smoke.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0

        qualityView = UIImageView(frame: .zero)
        qualityView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(qualityView)
        qualityView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45, constant: 0).isActive = true
        qualityView.setAspect(0.5)
        qualityView.center(withView: self, orientation: .horizontal)
        qualityView.verticalPin(to: self, orientation: .top, padding: 18)

        nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .silver
        addSubview(nameLabel)
        nameLabel.pinToEdges(of: self, orientation: .horizontal)
        nameLabel.verticalPin(to: self, orientation: .bottom, padding: -18)
    }

    private func updateQualityIcon() {
        switch quality {
        case .good:
            qualityView.image = isSelected ? R.image.badget_quality_good_selected() : R.image.badget_quality_good()
        case .great:
            qualityView.image = isSelected ? R.image.badget_quality_very_good_selected() : R.image.badget_quality_very_good()
        case .perfect:
            qualityView.image = isSelected ? R.image.badget_quality_excelent_selected() : R.image.badget_quality_excelent()
        default: break
        }
    }
}
