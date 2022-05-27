//
//  NavigationBar.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/1/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol AddAnADNavigationBarDelegate: AnyObject {
    func navigationBarDidPressCloseButton(_ navigationBar: NavigationBar)
}

class NavigationBar: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backButton: UIButton!

    // MARK: - Properties

    weak var delegate: AddAnADNavigationBarDelegate?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // MARK: - Actions

    @IBAction func backAction(_: UIButton) {
        delegate?.navigationBarDidPressCloseButton(self)
    }
}

@IBDesignable
extension NavigationBar: UILocalizable {
    @IBInspectable var l8nKey: String? {
        get { nil }
        set(key) {
            titleLabel.text = key?.localized
        }
    }
}
