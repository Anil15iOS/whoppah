//
//  BaseDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 23/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class BaseDialog: UIViewController {
    // MARK: Properties

    typealias CompletionHandler = () -> Void
    var onComplete: CompletionHandler?

    var tapBackgroundToDismiss = true

    // MARK: - IBOutlets

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGestures()
    }

    // MARK: - Private

    private func setUpGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapHandler(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    // MARK: - Actions

    @objc func backgroundTapHandler(_: UITapGestureRecognizer) {
        if tapBackgroundToDismiss {
            dismiss()
        }
    }

    @IBAction func closeAction(_: UIButton) {
        dismiss()
    }

    func dismiss() {
        dismiss(animated: true, completion: onComplete)
    }
}

extension BaseDialog: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Make sure that touches on the dialog view don't hide the view
        if let touchView = touch.view, touchView != view, touchView.isDescendant(of: view) {
            return false
        }
        return true
    }
}
