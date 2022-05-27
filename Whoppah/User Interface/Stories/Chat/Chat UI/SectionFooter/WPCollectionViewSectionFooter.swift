//
//  WPCollectionViewSectionFooter.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/20/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit

class WPCollectionViewSectionFooter: MSGSectionReusableView {
    @IBOutlet var label: UILabel!
    @IBOutlet var readIcon: UIImageView?

    override var style: MSGMessengerStyle? {
        didSet {
            guard let style = style as? MSGIMessageStyle else { return }

            label.font = style.footerFont
            label.textColor = style.footerTextColor
        }
    }

    override var title: String? {
        didSet {
            label.text = title
        }
    }

    var isRead: Bool = false {
        didSet {
            readIcon?.isHighlighted = isRead
        }
    }
}
