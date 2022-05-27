//
//  UIActivityViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 10/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

extension UIActivityViewController {
    static func createShareVC(activityItems: [Any], sourceView: UIView, completion: @escaping (UIActivity.ActivityType) -> Void) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, _, error in
            if success, error == nil, let activity = activity {
                completion(activity)
            }
        }
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
            // Otherwise the activity view won't show on iPad
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
        }
        activityViewController.popoverPresentationController?.sourceView = sourceView
        activityViewController.excludedActivityTypes = [.airDrop]
        return activityViewController
    }
}
