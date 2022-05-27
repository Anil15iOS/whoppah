//
//  ProfileCompletedHeaderView.swift
//  Whoppah
//
//  Created by Jose Camallonga on 15/06/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit

class ProfileCompletedHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let button = SecondaryLargeButton(frame: CGRect(x: 16, y: 12, width: frame.width - 32, height: 52))
        button.isEnabled = false
        button.setTitleColor(.space, for: .normal)
        button.layer.borderColor = UIColor.shinyBlue.cgColor
        button.setTitle(R.string.localizable.profile_complete(), for: .normal)

        let imageView = UIImageView(frame: CGRect(x: frame.width - 52, y: 25, width: 22, height: 22))
        imageView.image = R.image.ic_radio_blue()

        addSubview(button)
        addSubview(imageView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
