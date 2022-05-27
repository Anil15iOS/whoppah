//
//  ProductConfig.swift
//  WhoppahCore
//
//  Created by Eddie Long on 20/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct ProductConfig {
    public static let titleMaxLength = 35
    public static let descriptionMaxLength = 3000

    public static let minNumberImages = 5
    public static let maxNumberImages = 15

    public static let minimumImageSizeMB = 1024 * 1024 * 0.72
    public static let maxImageLengthPixels = 2500
    public static let minVideoDurationSeconds = 5.0
    public static let maxVideoDurationSeconds: Float = 20.0
    public static let maxNumberStyles: Int = 3
    public static let minimumPrice: Money = 1.00
    public static let minimumBidDefaultPercentage: Double = 0.6
    public static let minimumBidLowestPercentage: Double = 0.01
}
