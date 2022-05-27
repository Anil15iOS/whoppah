//
//  VideoSlider.swift
//  Whoppah
//
//  Created by Eddie Long on 09/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class VideoSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 8.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

    override func awakeFromNib() {
        setThumbImage(R.image.video_track_icon(), for: .normal)
        super.awakeFromNib()
    }
}
