//
//  CameraCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/25/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol MediaCellDelegate: AnyObject {
    func cellDidPressCloseButton(_ cell: MediaCell)
}

class MediaCell: UICollectionViewCell {
    // MARK: - Constants

    static let identifier = "MediaCell"
    static let nibName = "MediaCell"

    // MARK: - IBOutlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var videoIcon: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var borderView: UIView!

    // MARK: - Properties

    weak var delegate: MediaCellDelegate?
    var viewModel: MediaCellViewModel?

    var border: CAShapeLayer!
    override var isSelected: Bool { didSet { updateSelection() } }
    var selectable = true

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = false

        containerView.layer.borderColor = UIColor.orange.cgColor
        containerView.layer.masksToBounds = true
        border = CAShapeLayer()
        border.strokeColor = UIColor.steel.cgColor
        border.fillColor = UIColor.clear.cgColor
        // border.lineDashPattern = [2, 2]
        border.frame = borderView.bounds
        border.path = UIBezierPath(rect: borderView.bounds).cgPath
        borderView.layer.addSublayer(border)
        updateSelection()
    }

    // MARK: - State

    func setUp(with vm: MediaCellViewModel) {
        viewModel = vm
        switch vm.state {
        case .empty:
            videoIcon.isHidden = true
            photoView.isHidden = true
            containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
            border.isHidden = false
        case .loading:
            videoIcon.isHidden = true
            photoView.isHidden = false
            photoView.image = photoView.getPlaceholderImage()
            photoView.backgroundColor = UIImageView.defaultPlaceholderBackgroundColor
            photoView.contentMode = .center
            border.isHidden = true
        case let .photo(image):
            videoIcon.isHidden = true
            photoView.isHidden = false
            photoView.image = image
            photoView.contentMode = .scaleAspectFill
            photoView.backgroundColor = .clear
            border.isHidden = true
        case let .video(thumb, _, _):
            videoIcon.isHidden = false
            photoView.isHidden = false
            photoView.contentMode = .scaleAspectFill
            photoView.backgroundColor = .clear
            photoView.image = thumb
            border.isHidden = true
        }
    }

    private func updateSelection() {
        if isSelected, let vm = viewModel, vm.selectable {
            containerView.layer.borderWidth = 2.0
            closeButton.isHidden = false
            border.isHidden = true
        } else {
            containerView.layer.borderWidth = 0.0
            closeButton.isHidden = true
            border.isHidden = false
        }
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        delegate?.cellDidPressCloseButton(self)
    }
}
