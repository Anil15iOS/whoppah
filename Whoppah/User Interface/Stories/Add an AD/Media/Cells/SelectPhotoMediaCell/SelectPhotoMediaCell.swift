//
//  CameraCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/25/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol SelectPhotoMediaCellDelegate: AnyObject {
    func cellDidPressEditButton(_ cell: SelectPhotoMediaCell)
    func cellDidPressCloseButton(_ cell: SelectPhotoMediaCell)
}

class SelectPhotoMediaCell: UICollectionViewCell {
    // MARK: - Constants

    static let identifier = "SelectPhotoMediaCell"
    static let nibName = "SelectPhotoMediaCell"

    // MARK: - IBOutlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var mediaCountView: UIView!
    @IBOutlet var mediaCountLabel: UILabel!

    // MARK: - Properties

    weak var delegate: SelectPhotoMediaCellDelegate?
    var viewModel: SelectPhotoMediaCellViewModel?
    var mediaCountText: String? {
        didSet {
            mediaCountLabel.text = mediaCountText
            mediaCountView.isVisible = mediaCountText != nil
        }
    }

    var selectable = true

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 4
        layer.masksToBounds = true
    }

    // MARK: - State

    func setUp(with vm: SelectPhotoMediaCellViewModel) {
        viewModel = vm
        switch vm.state {
        case .loading:
            photoView.isHidden = false
            photoView.image = photoView.getPlaceholderImage()
            photoView.backgroundColor = UIImageView.defaultPlaceholderBackgroundColor
            photoView.contentMode = .center
        case .photo:
            photoView.isHidden = false
            photoView.image = vm.media
            photoView.contentMode = .scaleAspectFill
            photoView.backgroundColor = .clear
        }
        mediaCountText = vm.count
        closeButton.isHidden = false
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        delegate?.cellDidPressCloseButton(self)
    }

    @IBAction func editAction(_: UIButton) {
        delegate?.cellDidPressEditButton(self)
    }
}
