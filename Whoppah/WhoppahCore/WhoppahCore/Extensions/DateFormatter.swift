//
//  DateFormatter.swift
//  Whoppah
//
//  Created by Boris Sagan on 9/19/18.
//  Copyright © 2018 IT-nity. All rights reserved.
//

import Foundation

extension DateFormatter {
    public class func shortISOFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        return formatter
    }
}
