//
//  WPLightboxController.swift
//  Whoppah
//
//  Created by Eddie Long on 25/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import AVKit
import Foundation
import Lightbox

class WPLightboxController: LightboxController {
    weak var vm: AdDetailsViewModel!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if presentedViewController as? AVPlayerViewController != nil {
            vm.trackVideoViewed(isFullScreen: true)
        }
    }
}
