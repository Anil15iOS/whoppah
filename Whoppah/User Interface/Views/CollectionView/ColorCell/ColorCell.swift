//
//  ColorCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/8/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    static let nibName = "ColorCell"

    enum State {
        case normal
        case selected
    }

    // MARK: - IBOutlets

    @IBOutlet var colorView: UIView!
    @IBOutlet var selectedView: UIImageView!

    // MARK: - Properties

    var state: State = .normal { didSet { updateAppearanceAnimated() } }

    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.width / 2
            colorView.layer.cornerRadius = bounds.width / 2
        }
    }

    init() {
        colorView = ViewFactory.createView()
        selectedView = ViewFactory.createImage(image: nil)
        super.init(frame: .zero)
        addSubview(colorView)
        colorView.pinToAllEdges(of: self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = UIColor.silver.cgColor
        layer.cornerRadius = bounds.width / 2

        colorView.layer.cornerRadius = bounds.width / 2
        selectedView.alpha = 0.0
        selectedView.image = selectedView.image!.withRenderingMode(.alwaysTemplate)
        selectedView.tintColor = .white
    }

    // MARK: - Set Model

    func setUp(with colorHex: String) {
        colorView.backgroundColor = UIColor(hexString: colorHex)
        let isLight = colorView.backgroundColor!.isLight(threshold: 900) == true
        selectedView.tintColor = isLight ? UIColor.black : UIColor.white
        layer.borderWidth = isLight ? 1.0 : 0.0
    }

    func setUp(with viewModel: ColorViewModel) {
        let colorHex = viewModel.hex
        colorView.backgroundColor = UIColor(hexString: colorHex)
        let isLight = colorView.backgroundColor!.isLight(threshold: 900) == true
        layer.borderWidth = isLight ? 1.0 : 0.0
        selectedView.tintColor = isLight ? UIColor.black : UIColor.white
        state = viewModel.selected ? .selected : .normal
    }

    // MARK: - Private

    private func updateAppearanceAnimated() {
        UIView.animate(withDuration: 0.3) {
            self.updateAppearance()
        }
    }

    private func updateAppearance() {
        switch state {
        case .normal:
            selectedView.alpha = 0.0
        case .selected:
            selectedView.alpha = 1.0
        }
    }
}
