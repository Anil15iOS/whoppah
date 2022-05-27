//
//  ToastMessage.swift
//  Whoppah
//
//  Created by Eddie Long on 19/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

@IBDesignable
class ToastMessage: UIButton {
    @IBInspectable var showDurationSeconds: Double = 2.5
    @IBInspectable var animateInDuration: Double = 0.5
    @IBInspectable var animateOutDuration: Double = 0.2

    var totalDuration: Double {
        showDurationSeconds + animateInDuration + animateOutDuration
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func configure(title: String?, image: UIImage?) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
    }

    func show(in view: UIView) {
        guard isHidden else { return }
        isHidden = false
        frame.origin = CGPoint(x: 0, y: view.frame.maxY)
        var result: CGFloat = view.frame.maxY - frame.height
        let window = UIApplication.shared.keyWindow
        result -= window?.safeAreaInsets.bottom ?? 0

        UIView.animate(withDuration: animateInDuration, delay: 0, options: [UIView.AnimationOptions.curveEaseOut], animations: {
            self.frame.origin = CGPoint(x: 0.0, y: result)
        }, completion: { _ in
            UIView.animate(withDuration: self.animateOutDuration, delay: self.showDurationSeconds, options: [UIView.AnimationOptions.curveEaseIn], animations: {
                self.frame.origin = CGPoint(x: 0.0, y: view.frame.maxY)
            }, completion: { _ in
                self.isHidden = true
            })
        })
    }
}

private extension ToastMessage {
    func commonInit() {
        isHidden = true
        backgroundColor = .shinyBlue
        titleLabel?.font = .bodyText
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0)
        contentHorizontalAlignment = .left
    }
}
