//
//  RequestReviewDial.swift
//  Whoppah
//
//  Created by Eddie Long on 25/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import StoreKit

class RequestReviewDialog {
    static func create(fromVC: UIViewController, eventTracking: EventTrackingService) {
        guard canShowReview() else { return }

        onReviewShown()

        let dialog = YesNoDialog.create(withMessage: R.string.localizable.appreview_body(), andTitle: "WHOPPAH!") { button in
            switch button {
            case .yes:
                SKStoreReviewController.requestReview()
                eventTracking.appReview.trackSatisfiedClicked()
            case .no:
                let questionFormVC: QuestionFormViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
                if let nav = fromVC.navigationController {
                    nav.pushViewController(questionFormVC, animated: true)
                } else {
                    fromVC.present(questionFormVC, animated: true, completion: nil)
                }
                eventTracking.appReview.trackNotSatisfiedClicked()
            case .cancel:
                eventTracking.appReview.trackAbandonReview()
            }
        }
        dialog.closeButtonAction = .cancel
        fromVC.present(dialog, animated: true, completion: nil)
    }

    static let key = "last_review_epoch"
    // Apple only allow 3 reviews a year
    static let intervalBetweenReviews = Double(365.0 / 3.0).rounded(.up)

    static func canShowReview(_ key: String = RequestReviewDialog.key, targetInterval: Int = Int(intervalBetweenReviews), component: Calendar.Component = .day) -> Bool {
        let now = Date()
        let previous = UserDefaults.standard.double(forKey: key)
        if previous > Double.ulpOfOne {
            let previousDate = Date(timeIntervalSince1970: previous)
            let calender = Calendar.current
            let components = calender.dateComponents([component], from: previousDate, to: now)
            if let intervalSinceLastReview = components.value(for: component) {
                if intervalSinceLastReview >= targetInterval {
                    return true
                } else {
                    return false
                }
            }
        }
        return true
    }

    static func onReviewShown(_ key: String = RequestReviewDialog.key) {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: key)
    }

    static func reset(_ key: String = RequestReviewDialog.key) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
