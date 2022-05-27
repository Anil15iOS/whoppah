//
//  UINavigationController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 08/06/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit

extension UINavigationController {
    typealias TransitionCompletion = () -> Void
    func pushViewController(viewController: UIViewController, animated: Bool, completion: TransitionCompletion?) {
        pushViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func popViewController(animated: Bool, completion: TransitionCompletion?) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func popToRootViewController(animated: Bool, completion: TransitionCompletion?) {
        popToRootViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
