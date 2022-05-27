//
//  FirstAutoreplyCollectionViewCell.swift
//  Whoppah
//
//  Created by Levon Hovsepyan on 06.04.21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import MessengerKit

class FirstAutoreplyCollectionViewCell: MSGMessageCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentContainer: UIView!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentContainer.layer.borderWidth = 0.5
        contentContainer.layer.borderColor = UIColor.smoke.cgColor
    }

}
