//
//  StepView.swift
//  Whoppah
//
//  Created by Eddie Long on 02/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct StepView {
    static func createStepView(forStep current: Int, withTotal total: Int) -> UIView {
        let base = ViewFactory.createRoundedRect(withColor: UIColor(hexString: "#F3F4F6"), radius: 5, height: 32)

        let text = R.string.localizable.commonStepProgress(current, total)
        let foreground = ViewFactory.createLabel(text: text)
        foreground.font = UIFont.systemFont(ofSize: 11)
        foreground.textColor = R.color.orange()
        base.addSubview(foreground)
        foreground.center(withView: base, orientation: .vertical)
        foreground.pinToEdges(of: base, orientation: .horizontal, padding: 8)
        return base
    }
}
