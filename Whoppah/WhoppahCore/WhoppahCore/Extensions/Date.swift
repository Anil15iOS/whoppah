//
//  Date.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/26/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

private let todayFormatter = DateFormatter()
private let otherDayFormatter = DateFormatter()

extension Date {
    public func getReadableDate() -> String {
        todayFormatter.dateFormat = "HH:mm"
        if Calendar.current.isDateInToday(self) {
            return todayFormatter.string(from: self)
        } else {
            otherDayFormatter.dateStyle = .short
            otherDayFormatter.doesRelativeDateFormatting = true

            return "\(otherDayFormatter.string(from: self)) \(todayFormatter.string(from: self))"
        }
    }

    public func iso8601Text() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return formatter.string(from: self)
    }
}
