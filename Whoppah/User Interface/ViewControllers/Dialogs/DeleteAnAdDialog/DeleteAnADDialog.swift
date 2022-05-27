//
//  DeleteAnADDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/3/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

class DeleteAnADDialog: UIViewController, RadioButtonDelegate {
    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yesButton: PrimaryLargeButton!
    @IBOutlet var noButton: SecondaryLargeButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var soldWithWhoppah: RadioButton!
    @IBOutlet var notSoldWithWhoppah: RadioButton!
    @IBOutlet var soldWithWhoppahContainer: UIView!
    @IBOutlet var notSoldWithWhoppahContainer: UIView!

    // MARK: - Properties

    // AdDeletionReason only sent if the ad is deleted
    var callback: ((Bool, GraphQL.ProductWithdrawReason?) -> Void)?
    private var decision: Bool = false

    private var deletionReason: GraphQL.ProductWithdrawReason {
        if soldWithWhoppah.isSelected {
            return .soldWhoppah
        }
        return .soldElsewhere
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        soldWithWhoppah.isSelected = true
        notSoldWithWhoppah.isSelected = false

        soldWithWhoppah.delegate = self
        notSoldWithWhoppah.delegate = self
        yesButton.style = .primary

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapSoldContainer(_:)))
        soldWithWhoppahContainer.addGestureRecognizer(tap1)

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapNotSoldContainer(_:)))
        notSoldWithWhoppahContainer.addGestureRecognizer(tap2)
    }

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        decision = false
        dismiss(animated: true) { [unowned self] in
            self.callback?(self.decision, nil)
        }
    }

    @IBAction func yesAction(_: TextButton) {
        decision = true
        dismiss(animated: true) { [unowned self] in
            self.callback?(self.decision, self.deletionReason)
        }
    }

    @IBAction func noAction(_: PrimaryLargeButton) {
        decision = false
        dismiss(animated: true) { [unowned self] in
            self.callback?(self.decision, nil)
        }
    }

    @objc func tapSoldContainer(_: PrimaryLargeButton) {
        radioButtonDidChangeState(soldWithWhoppah)
    }

    @objc func tapNotSoldContainer(_: PrimaryLargeButton) {
        radioButtonDidChangeState(notSoldWithWhoppah)
    }

    // MARK: RadioButtonDelegate

    func radioButtonDidChangeState(_ radioButton: RadioButton) {
        let isSold = (radioButton == soldWithWhoppah)
        notSoldWithWhoppah.isSelected = !isSold
        soldWithWhoppah.isSelected = isSold
    }
}
