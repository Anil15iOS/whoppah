//
//  Date+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension Date {
    func activeDaysText() -> String? {
        let now = Date()
        let components = Calendar.current.dateComponents([.day], from: self, to: now)
        guard let days = components.day else {
            return nil
        }

        // We always display 1 day
        let minDays = max(days, 1)
        return R.string.localizable.ad_details_ad_created_days_active(minDays)
    }

    public func activeJoinPeriodText() -> String? {
        let now = Date()
        let components = Calendar.current.dateComponents([.month, .year], from: self, to: now)
        guard let months = components.month, let years = components.year else {
            return nil
        }

        let componentsWeeks = Calendar.current.dateComponents([.weekOfYear], from: self, to: now)
        guard let weeks = componentsWeeks.weekOfYear else {
            return nil
        }

        if years == 0 {
            if months <= 2, weeks <= 8 {
                if months < 1, weeks <= 1 {
                    return R.string.localizable.member_join_1_week()
                }
                return R.string.localizable.member_join_multiple_weeks(weeks)
            }
            return R.string.localizable.member_join_multiple_months(months)
        } else {
            if years == 1, months == 0 {
                return R.string.localizable.member_join_one_year()
            }
        }

        return R.string.localizable.member_join_multiple_years(years)
    }

    public func textUntilAdExpiry() -> String? {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: self)
        guard let days = components.day, let hours = components.hour, let minutes = components.minute else {
            return nil
        }

        if days > 1 {
            return R.string.localizable.my_ad_expiry_days(days)
        } else if hours < 1 {
            if minutes > 1 {
                return R.string.localizable.my_ad_expiry_minutes(minutes)
            } else {
                return R.string.localizable.my_ad_expiry_minute()
            }
        }

        return R.string.localizable.my_ad_expiry_hours(hours)
    }
}
