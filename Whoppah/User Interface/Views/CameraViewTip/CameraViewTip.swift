//
//  CameraViewTip.swift
//  Whoppah
//
//  Created by Eddie Long on 09/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class CameraViewTip: RoundedView {
    @IBOutlet var textLabel: UILabel!

    var text: String = "" {
        didSet {
            self.textLabel.text = text
            self.textLabel.sizeToFit()
            self.setNeedsLayout()
            self.layoutSubviews()
        }
    }

    func show(animate: Bool = true) {
        layer.removeAllAnimations()
        let wasHidden = isHidden
        isHidden = false
        if animate {
            if wasHidden {
                alpha = 0.0
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 1.0
                })
            }
        } else {
            alpha = 1.0
        }
    }

    func hide(animate: Bool = true) {
        if isHidden == false {
            layer.removeAllAnimations()
            if animate {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0.0
                }, completion: { _ in
                    self.isHidden = true
                })
            } else {
                alpha = 0.0
                isHidden = true
            }
        }
    }
}
