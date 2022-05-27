//
//  HowItWorksDialog.swift
//  Whoppah
//
//  Created by Alisa Martirosyan on 08.07.21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import RxSwift

class HowItWorksDialog: BaseDialog {

    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var howItWorksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wholeView.layer.cornerRadius = 4
        wholeView.layer.masksToBounds = true
    }
    
    @IBAction override func closeAction(_ sender: UIButton) {
        dismiss()
    }
}
