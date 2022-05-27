//
//  ProfileMissingHeaderView.swift
//  Whoppah
//
//  Created by Jose Camallonga on 15/06/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxCocoa
import UIKit

class ProfileMissingHeaderView: UIView {
    private let tap = UITapGestureRecognizer()

    init(frame: CGRect, missing: String) {
        super.init(frame: frame)

        let imageView = UIImageView(frame: CGRect(x: 16, y: 10, width: 18, height: 20))
        imageView.image = R.image.ic_warning()

        let label = UILabel(frame: CGRect(x: 46, y: 0, width: frame.width - 78, height: 44))
        label.textColor = .space
        label.font = .bodySmall
        label.text = missing
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2

        let edit = UIImageView(frame: CGRect(x: frame.width - 32, y: 10, width: 20, height: 20))
        edit.image = R.image.ic_pencil_circle()?.tinted(with: .orange)

        let lane = UIView(frame: CGRect(x: 0, y: 43.5, width: frame.width, height: 0.5))
        lane.backgroundColor = .lightGray

        addSubview(imageView)
        addSubview(label)
        addSubview(edit)
        addSubview(lane)

        addGestureRecognizer(tap)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var event: ControlEvent<UITapGestureRecognizer> {
        tap.rx.event
    }
}
