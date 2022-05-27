//
//  ItemReceivedCollectionViewCell.swift
//  Whoppah
//
//  Created by Levon Hovsepyan on 11.05.21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import MessengerKit

class ItemReceivedCollectionViewCell: MSGMessageCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.smoke.cgColor
    }
}
