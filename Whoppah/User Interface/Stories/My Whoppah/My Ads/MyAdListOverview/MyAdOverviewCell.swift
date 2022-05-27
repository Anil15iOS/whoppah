//
//  MyAdOverviewCell.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol MyAdOverviewDelegate: AnyObject {
    func didSelectEdit(cell: MyAdOverviewCell)
    func didSelectDelete(cell: MyAdOverviewCell)
    func didSelectRepost(cell: MyAdOverviewCell)
}

class MyAdOverviewCell: UICollectionViewCell {
    static let nibName = "MyAdOverviewCell"
    static let identifier = "MyAdOverviewCell"

    @IBOutlet var imageview: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var repostButton: UIButton!
    weak var delegate: MyAdOverviewDelegate?
    var data: AdOverviewCellData?

    override func awakeFromNib() {
        super.awakeFromNib()
        imageview.backgroundColor = .smoke
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let superview = imageview.superview else { return }
        imageview.applyShadowWithCorner(containerView: superview, cornerRadius: 4)
    }

    func configure(withData data: AdOverviewCellData) {
        self.data = data
        imageview.setImage(forUrl: data.imageUrl)
        itemTitle.text = data.title
        itemPrice.text = data.price
        editButton.isVisible = data.canEdit
        deleteButton.isVisible = data.canDelete
        repostButton.isVisible = data.canRepost
    }

    @IBAction func editPressed(_: UIButton) {
        delegate?.didSelectEdit(cell: self)
    }

    @IBAction func deletePressed(_: UIButton) {
        delegate?.didSelectDelete(cell: self)
    }

    @IBAction func repostPressed(_: UIButton) {
        delegate?.didSelectRepost(cell: self)
    }
}
