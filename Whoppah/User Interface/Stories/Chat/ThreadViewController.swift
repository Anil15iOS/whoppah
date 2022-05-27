//
//  ThreadViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/20/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import SkeletonView
import UIKit
import WhoppahCore
import WhoppahCoreNext
import RxSwift
import Resolver

class ThreadViewController: UIViewController {
    // MARK: - IBOutlets

//    @IBOutlet var navigationBarBackgroundView: UIView!
    @IBOutlet var chatContainer: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var adImageView: UIImageView!
    @IBOutlet var otherUserLabel: UILabel!
    @IBOutlet var adNameLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var bidButton: UIButton!
    @IBOutlet var bidStackview: UIStackView!
    @IBOutlet var bidTextFieldContainerView: UIView!
    @IBOutlet var currencyImageView: UIImageView!
    @IBOutlet var bidTextField: UITextField!

    var viewModel: ThreadViewModel!
    
    @Injected private var crashReporter: CrashReporter
    @Injected private var pushNotifications: PushNotificationsService
    
    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBidTextField()
        setUpNavigationBar()
        setUpViewModel()
        setUpChatView()
        
        bidButton.addTarget(self, action: #selector(bidAction(_:)), for: .touchUpInside)
        
        viewModel.outputs.showBidUI
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] show in
                self?.toggleBidUI(enabled: show)
            }).disposed(by: bag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.assignThreadID()
        crashReporter.log(event: "enter_chat_thread",
                          withInfo: ["thread_id": pushNotifications.openedThreadID ?? -1])
    }

    deinit {
        crashReporter.log(event: "leave_chat_thread",
                          withInfo: ["thread_id": pushNotifications.openedThreadID ?? -1])
    }

    // MARK: - Private
    
    @objc func bidAction(_: Any) {
        guard let amount = bidTextField.text!.getPrice() else { return }
        viewModel.doBid(amount: amount)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.getMessages(fetchLatest: true)
                self.onBidSent()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                if let biderror = error as? ChatViewModel.BidError {
                    switch biderror {
                    case let .minPriceNotMet(minPrice):
                        let text = minPrice.formattedPrice(includeCurrency: true)
                        self.showErrorDialog(title: R.string.localizable.chatErrorMinBidNotMetTitle(),
                                             message: R.string.localizable.chatErrorMinBidNotMet(text))
                    }
                }
                self.showError(error)
            }).disposed(by: bag)
    }
    
    private func setUpBidTextField() {
        bidTextFieldContainerView.layer.cornerRadius = bidButton.bounds.height / 2
        bidTextFieldContainerView.layer.borderColor = UIColor.silver.cgColor
        bidTextFieldContainerView.layer.borderWidth = 1.0

        bidButton.layer.cornerRadius = bidButton.bounds.height / 2
        bidButton.layer.borderColor = UIColor.shinyBlue.cgColor
        bidButton.layer.borderWidth = 1

        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]

        bidTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.chat_thread_place_bid_placeholder(),
                                                                attributes: attributes)

        bidTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: bidButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
    func onBidSent() {
        bidTextField.text = nil
        bidTextField.resignFirstResponder()
    }

    func toggleBidUI(enabled: Bool) {
        bidStackview.arrangedSubviews.forEach { $0.isVisible = enabled }
        bidStackview.isVisible = enabled
        
        adImageView.isVisible = !enabled
        otherUserLabel.isVisible = !enabled
        statusView.superview?.isVisible = !enabled
        
        if enabled {
            (adImageView.superview as? UIStackView)?.removeArrangedSubview(adImageView)
            (otherUserLabel.superview as? UIStackView)?.removeArrangedSubview(otherUserLabel)
            (statusView.superview as? UIStackView)?.removeArrangedSubview(statusView)
        }
    }

    private func setUpNavigationBar() {
        adImageView.backgroundColor = .smoke

        adImageView.isUserInteractionEnabled = true
        adImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAdAction)))

        adNameLabel.isUserInteractionEnabled = true
        adNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAdAction)))

        statusView.layer.cornerRadius = statusView.bounds.height / 2
    }

    private func setUpChatView() {
        if let chat = viewModel.coordinator.getAndClearChatVC() {
            addChild(chat)
            chatContainer.addSubview(chat.view)
            chat.didMove(toParent: self)
            chat.view.translatesAutoresizingMaskIntoConstraints = false
            chat.view.pinToEdges(of: chatContainer, orientation: .horizontal)
            chat.view.pinToEdges(of: chatContainer, orientation: .vertical)
        }
    }

    private func setUpViewModel() {
        viewModel.onThreadUpdated = { [weak self] result in
            self?.onThreadUpdated(result: result)
        }
//        navigationBarBackgroundView.showAnimatedGradientSkeleton()
        viewModel.fetchThread()
    }

    private func onThreadUpdated(result: Result<ThreadUIData, Error>) {
        switch result {
        case let .success(data):
//            navigationBarBackgroundView.hideSkeleton()
            adImageView.setImage(forUrl: data.imageUrl)
            otherUserLabel.text = data.userTitle
            adNameLabel.text = data.title
            statusLabel.isVisible = true
            statusLabel.text = data.status
            statusView.isVisible = data.statusVisible
            moreButton.isVisible = data.showReportOptions
        case let .failure(error):
            showError(error)
        }
    }

    // MARK: - Actions

    @IBAction func backAction(_: UIButton) {
        dismiss()
    }

    @IBAction func moreAction(_: UIButton) {
        viewModel.showMore()
    }

    @IBAction func helpAction(_: UIButton) {
        viewModel.showHelp()
    }

    @objc func openAdAction() {
        viewModel.openThreadItem()
    }

    private func dismiss() {
        pushNotifications.openedThreadID = nil
        viewModel.coordinator.dismiss()
    }
}

// MARK: - ReportDialogDelegate

extension ThreadViewController: ReportDialogDelegate {
    func reportDialogDidSelectUserReport(_ dialog: ReportDialog) {
        dialog.dismiss(animated: false, completion: nil)
        viewModel.reportUser()
    }

    func reportDialogDidSelectProductReport(_ dialog: ReportDialog) {
        dialog.dismiss(animated: false, completion: nil)
        viewModel.reportProduct()
    }

    func reportDialogDidSelectBlockUser(_ dialog: ReportDialog) {
        dialog.dismiss(animated: false, completion: nil)
    }
}
