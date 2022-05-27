//
//  ChatViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVKit
import DifferenceKit
import IQKeyboardManagerSwift
import KafkaRefresh
import Lightbox
import MessengerKit
import OpalImagePicker
import Photos
import RxCocoa
import RxSwift
import StoreKit
import UIKit
import WhoppahCore
import WhoppahCoreNext
import TLPhotoPicker
import Resolver

extension Int: Differentiable {}

class ChatViewController: MSGMessengerViewController {
    // MARK: - Properties

    var viewModel: ChatViewModel! {
        didSet {
            if isViewLoaded {
                setupBindings()
            }
        }
    }

    // var ad: Ad?
    var route: Navigator.Route?

    var cachedSizes = [Int: CGSize]()
    var customInputView: WPInputView!

    @Injected private var eventTracking: EventTrackingService
    private let bag = DisposeBag()
    private var pageFetchCount = PublishRelay<Int>()

    // MARK: - Chat Style
    
    override var style: MSGMessengerStyle {
        WPChatStyle()
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        setUpPullToRefresh()
        setUpInputView()
        setupBindings()
        collectionView.shouldIgnoreScrollingAdjustment = true

        // This is awful
        // See WHOPPAH-746 to understand why we need to do this
        // TL;DR MessengerKit adjusts the bottom InputView to fill the entire screen if a subscreen uses a textfield
        if let last = view.layoutGuides.last {
            let lastLayoutType = type(of: last).description()
            if lastLayoutType.contains("MessengerKit") {
                view.removeLayoutGuide(last)
            } else {
                // Added to ensure we (as devs) catch this issue and understand the implications
                fatalError("Expected layoutGuide to be a MessengerKit layout guide")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
        setUpRouting()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Input View

    private func setUpInputView() {
        guard let inputView = messageInputView as? WPInputView else { return }
        customInputView = inputView
        
        inputView.cameraButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.coordinator.selectCamera(delegate: self)
        }.disposed(by: bag)
        inputView.galleryButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.coordinator.selectPhoto(delegate: self)
        }.disposed(by: bag)
        
        inputView.didTapButton = { [weak self] button in
            switch button {
            case .bidding:
                self?.viewModel.showHowItWorks()
            case .delivery:
                self?.viewModel.showDeliveryInfo()
            }
        }
    }

    private func setupBindings() {
        pageFetchCount
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 1)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] _ in
                // Ignore the first page
                guard let self = self else { return }

                self.collectionView.headRefreshControl.isHidden = false
                self.collectionView.headRefreshControl.beginRefreshing()
                self.getMessages()
            })
            .disposed(by: bag)

        viewModel.outputs.showReviewRequest
            .take(1)
            .asDriver(onErrorJustReturn: ())
            .delay(RxTimeInterval.milliseconds(200))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                RequestReviewDialog.create(fromVC: self, eventTracking: self.eventTracking)
            }).disposed(by: bag)

        viewModel.outputs.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        viewModel.outputs.threadLoaded
            .take(1)
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.getMessages()
            }).disposed(by: bag)

        viewModel.outputs.fetchMessages
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] latest in
                self?.getMessages(fetchLatest: latest)
            }).disposed(by: bag)

        viewModel.outputs.reloadMessages
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.reloadMessages()
            }).disposed(by: bag)

        viewModel.onSendMessage = { [weak self] text in
            self?.sendMessage(text)
        }
    }

    // MARK: - Messages

    private func getMessages(fetchLatest: Bool = false) {
        viewModel.load(fetchLatest: fetchLatest) { [weak self] old, new, onDataSet in
            guard let self = self else { return }
            let scrollToBottom = fetchLatest || self.collectionView.numberOfSections == 0
            if !scrollToBottom {
                // To fix flicker we need to perform this little 'trick'
                // https://stackoverflow.com/questions/25548257/uicollectionview-insert-cells-above-maintaining-position-like-messages-app/34192787
                CATransaction.begin()
                CATransaction.setDisableActions(true)
            }
            let bottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y

            let changeset = StagedChangeset(source: old, target: new)
            self.collectionView.reloadDiff(using: changeset, setData: onDataSet, completed: { _ in
                self.updateSectionFooters()
                self.collectionView.layoutTypingLabelIfNeeded()
                if !scrollToBottom {
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: self.collectionView.contentSize.height - bottomOffset), animated: false)
                    CATransaction.commit()
                } else {
                    self.collectionView.scrollToBottom(animated: true)
                }
                if self.viewModel.paginator.hasMorePages() {
                    self.collectionView.headRefreshControl.endRefreshing()
                } else {
                    self.collectionView.headRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "")
                    // Kafka has a bug where it keeps the control visible but with empty text
                    // We don't want anything now as we're done with it
                    self.collectionView.headRefreshControl.isHidden = true
                }
                self.collectionView.footRefreshControl.endRefreshing()
            })
        }
    }

    private func setUpRouting() {
        /* guard let route = route else { return }

         self.route = nil
         */
    }

    private func reloadMessages() {
        cachedSizes.removeAll()
        collectionView.reloadData()
    }

    // MARK: - Override

    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        guard let customView = inputView as? WPInputView else { return }
        guard let text = customView.messageTextView.text else { return }
        sendMessage(text)
    }

    private func sendMessage(_ text: String, image: Data? = nil, video: Data? = nil) {
        viewModel.sendMessage(text, image: image, video: video) { [weak self] old, new, completion in
            guard let self = self else { return }
            let changeset = StagedChangeset(source: old, target: new)
            self.collectionView.reloadDiff(using: changeset, setData: {
                completion()
            }, completed: { _ in
                self.updateSectionFooters()
                self.collectionView.scrollToBottom(animated: true)
                self.collectionView.layoutTypingLabelIfNeeded()
            })
        }
    }

    // MARK: -

    private func updateSectionFooters() {
        for (sectionIndex, section) in viewModel.sections.enumerated() {
            guard let last = section.last else { continue }
            let lastMessage = viewModel.messages[last]
            guard lastMessage.user.isSender else { continue }
            let indexPath = IndexPath(row: 0, section: sectionIndex)
            let view = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            if let footer = view as? WPCollectionViewSectionFooter {
                footer.isRead = !lastMessage.isUnread
                footer.title = lastMessage.msgMessage.sentAt.getReadableDate()
            }
        }
    }

    private func setUpPullToRefresh() {
        collectionView.bindFootRefreshHandler({ [weak self] in
            self?.getMessages(fetchLatest: true)
        }, themeColor: UIColor.orange, refreshStyle: .native)

        collectionView.bindHeadRefreshHandler({}, themeColor: UIColor.orange, refreshStyle: .native)
    }
}

extension ChatViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.paginator.hasMorePages() else { return }
        if indexPath.section < 1, collectionView.isDragging {
            pageFetchCount.accept(viewModel.paginator.nextPage)
        }
    }

    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let message = dataSource?.message(for: indexPath) else {
            fatalError("ChatMessage not defined for \(indexPath)")
        }

        let count = collectionView.numberOfItems(inSection: indexPath.section)
        let isLast = indexPath.item + 1 == count
        var cell: MSGMessageCell!
        switch message.body {
        case .text:
            let identifier = message.user.isSender ? "outgoingText" : "incomingText"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPTextCell
        case .emoji:
            let identifier = message.user.isSender ? "outgoingEmoji" : "incomingEmoji"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MSGMessageCell
        case .image, .imageFromUrl:
            let identifier = message.user.isSender ? "outgoingImage" : "incomingImage"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MSGMessageCell
        case .video:
            let identifier = message.user.isSender ? "outgoingVideo" : "incomingVideo"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MSGMessageCell
        case let .custom(dataMessage):
            guard let dataMessage = dataMessage as? ChatMessage else { return UICollectionViewCell() }
            cell = getCustomCell(dataMessage: dataMessage, message: message, indexPath: indexPath)
        }

        cell.delegate = self
        cell.message = message
        cell.style = style
        cell.isLastInSection = isLast

        if count > 1 {
            updatePreviousCell(of: indexPath, in: collectionView)
        }

        return cell
    }

    private func getCustomCell(dataMessage: ChatMessage, message: MSGMessage, indexPath: IndexPath) -> MSGMessageCell {
        var cell: MSGMessageCell?
        switch dataMessage.type {
        case .text:
            let identifier = message.user.isSender ? "outgoingText" : "incomingText"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPTextCell
        case .askPay:
            let identifier = "askPay"
            let askPayCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPAskPayCell
            askPayCell.askPayCellDelegate = viewModel
            cell = askPayCell
        case let .paymentCompletedSeller(payload):
            let identifier = "paymentCompleted"
            let paymentCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPPaymentCompletedCell
            paymentCell.isExpanded = orderDialogExpanded.getValue(forKey: payload.orderId)
            paymentCell.cellDelegate = viewModel
            cell = paymentCell
        case let .paymentCompletedMerchant(payload):
            let identifier = "paymentCompleted"
            let paymentCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPPaymentCompletedCell
            paymentCell.isExpanded = orderDialogExpanded.getValue(forKey: payload.orderId)
            paymentCell.cellDelegate = viewModel
            cell = paymentCell
        case let .paymentCompletedBuyer(payload):
            let identifier = "paymentCompleted"
            let paymentCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPPaymentCompletedCell
            paymentCell.isExpanded = orderDialogExpanded.getValue(forKey: payload.orderId)
            paymentCell.cellDelegate = viewModel
            cell = paymentCell
        case .askTrackingID:
            let identifier = "askTrackingID"
            let trackingCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPAskTrackingIDCell
            trackingCell.askTrackingIDCellDelegate = viewModel
            cell = trackingCell
        case .trackingID:
            let identifier = "trackingID"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPTrackingIDCell
        case let .didProductReceived(payload):
            let identifier = "didReceiveProductCell"
            let didReceiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPDidReceiveProductCell
            didReceiveCell.showDialog = receiveDialogVisibility.getValue(forKey: payload.orderID)
            didReceiveCell.didReceiveProductDelegate = viewModel
            cell = didReceiveCell
        case let .orderIncomplete(payload):
            let identifier = "orderIncompleteCell"
            let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPOrderIncompleteCell
            orderCell.cellDelegate = self
            orderCell.isExpanded = orderIncompleteDialogExpanded.getValue(forKey: payload.orderID)
            cell = orderCell
        case .itemReceived(let payload):
            let identifier = "ItemReceivedCollectionViewCell"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ItemReceivedCollectionViewCell
            (cell as! ItemReceivedCollectionViewCell).descriptionLabel.attributedText = payload.attributedPayload
            (cell as! ItemReceivedCollectionViewCell).titleLabel.text = R.string.localizable.chatItemReceivedTitle()
        case .firstReply(let payload):
            let identifier = "autoreplyMessageIdentifier"
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FirstAutoreplyCollectionViewCell
            (cell as! FirstAutoreplyCollectionViewCell).contentLabel.attributedText = payload
            (cell as! FirstAutoreplyCollectionViewCell).titleLabel.text = R.string.localizable.chatAutoreplyTitle()
        case .media:
            if message.user.isSender {
                let identifier = "outgoingMedia"
                let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPMediaCell
                orderCell.mediaDelegate = self
                cell = orderCell
            } else {
                let identifier = "incomingMedia"
                let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPMediaCell
                orderCell.mediaDelegate = self
                cell = orderCell
            }
        case let .bid(payload):
            cell = getBidCell(message: message, indexPath: indexPath, payload: payload)
        }

        guard let finalCell = cell else {
            fatalError("Should never be trying to create an unknown cell")
        }

        return finalCell
    }

    private func getBidCell(message: MSGMessage, indexPath: IndexPath, payload: BidPayload) -> MSGMessageCell {
        var cell: MSGMessageCell!
        if message.user.isSender {
            let identifier = "outgoingBid"
            let outgoingBidCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPOutgoingBidCell
            outgoingBidCell.cellDelegate = self
            outgoingBidCell.isExpanded = outgoingBidDialogExpanded.getValue(forKey: payload.id)
            cell = outgoingBidCell
        } else {
            let identifier = "incomingBid"
            let incomingBidCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WPIncomingBidCell
            incomingBidCell.bidCellDelegate = self
            cell = incomingBidCell
        }

        return cell
    }

    open override func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let message = dataSource?.message(for: indexPath) else {
            fatalError("Message not defined for \(indexPath)")
        }
        return size(for: message)
    }

    func size(for message: MSGMessage) -> CGSize {
        if let size = cachedSizes[message.id] { return size }
        guard let style = style as? WPChatStyle else { return .zero }
        let size = style.size(for: message, in: collectionView)
        cachedSizes[message.id] = size
        return size
    }

    private func updatePreviousCell(of indexPath: IndexPath, in collectionView: UICollectionView) {
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let cell = collectionView.cellForItem(at: previousIndexPath) as? MSGMessageCell
        cell?.isLastInSection = false
    }

    struct ChatDialogConfig {
        let color: UIColor
        let icon: UIImage?
        let title: String
        let description: String
    }

    private func getChatDialog(config: ChatDialogConfig,
                               cell: MSGMessageCell,
                               buttonView: UIView,
                               tag: Int? = nil,
                               dismiss: @escaping ((UIViewController) -> Void)) -> ChatCellDialog {
        let vc = ChatCellDialog(color: config.color,
                                icon: config.icon,
                                title: config.title,
                                description: config.description,
                                dismiss: dismiss)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false

        let origin = buttonView.convert(buttonView.frame.origin, to: cell)
        if let tag = tag {
            vc.view.tag = tag
        }
        cell.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.pinToEdges(of: buttonView, orientation: .vertical)
        vc.view.horizontalPin(to: buttonView, orientation: .leading, padding: origin.y)
        vc.view.horizontalPin(to: view, orientation: .trailing)
        vc.view.pinToAllEdges(of: buttonView)
        return vc
    }
}

// MARK: - MSGDataSource

extension ChatViewController: MSGDataSource {
    func numberOfSections() -> Int {
        viewModel.sections.count
    }

    func numberOfMessages(in section: Int) -> Int {
        viewModel.sections[section].count
    }

    func message(for indexPath: IndexPath) -> MSGMessage {
        viewModel.messages[viewModel.sections[indexPath.section][indexPath.row]].msgMessage
    }

    func footerTitle(for section: Int) -> String? {
        viewModel.sectionFooterTitle(section)
    }

    func headerTitle(for section: Int) -> String? {
        let lastItem = viewModel.sections[section].last!
        return viewModel.messages[lastItem].msgMessage.user.displayName
    }
}

// MARK: - MSGDelegate

extension ChatViewController: MSGDelegate {
    func avatarTapped(for user: MSGUser) {
        guard let user = user as? ChatUser else { return }
        viewModel.onAvatarTapped(user)
    }
}

// MARK: - IncomingBidCellDelegate

extension ChatViewController: WPIncomingBidCellDelegate {
    func incomingBidCellDidClickAccept(_ cell: WPIncomingBidCell, buttonView: UIView) {
        guard let amount = cell.amount else { return }
        let amountText = amount.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true)
        let config = ChatDialogConfig(color: R.color.acceptDialogColor()!,
                                      icon: R.image.chatCellAcceptedIcon(),
                                      title: R.string.localizable.chatCellDialogAcceptBidTitle(),
                                      description: R.string.localizable.chatCellDialogAcceptBidDescription(amountText))
        let vc = getChatDialog(config: config,
                               cell: cell,
                               buttonView: buttonView) { vc in
            vc.removeFromParentVC()
        }
        let buttonStack = ViewFactory.createHorizontalStack(spacing: 8)
        let acceptButton = ViewFactory.createPrimaryButton(text: R.string.localizable.chatCellDialogAcceptBidButton())
        buttonStack.addArrangedSubview(acceptButton)
        acceptButton.rx.tap.bind { [weak self] in
            vc.removeFromParentVC()
            guard let bid = cell.bidId else { return }
            self?.viewModel.onBidAction(id: bid, accepted: true)
        }.disposed(by: bag)
        acceptButton.setHeightAnchor(48)
        buttonStack.distribution = .fillEqually
        vc.buttonContainer.addSubview(buttonStack)
        buttonStack.pinToAllEdges(of: vc.buttonContainer)
    }

    func incomingBidCellDidClickDeny(_ cell: WPIncomingBidCell, buttonView: UIView) {
        guard let amount = cell.amount else { return }
        let amountText = amount.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true)
        let config = ChatDialogConfig(color: R.color.rejectDialogColor()!,
                                      icon: R.image.chatCellRejectedIcon(),
                                      title: R.string.localizable.chatCellDialogRejectTitle(amountText),
                                      description: R.string.localizable.chatCellDialogRejectDescription())
        let vc = getChatDialog(config: config,
                               cell: cell,
                               buttonView: buttonView) { vc in
            vc.removeFromParentVC()
        }
        let buttonStack = ViewFactory.createHorizontalStack(spacing: 8)
        let rejectButton = ViewFactory.createSecondaryButton(text: R.string.localizable.chatBidIncomingCellRejectButton(),
                                                             buttonColor: R.color.rejectDialogColor())
        buttonStack.addArrangedSubview(rejectButton)
        rejectButton.rx.tap.bind { [weak self] in
            vc.removeFromParentVC()
            guard let bid = cell.bidId else { return }
            self?.viewModel.onBidAction(id: bid, accepted: false)
        }.disposed(by: bag)
        rejectButton.setHeightAnchor(48)

        let counterButton = ViewFactory.createPrimaryButton(text: R.string.localizable.chatBidIncomingCellCounterButton(),
                                                            style: .shinyBlue)

        counterButton.setImage(R.image.ic_buy_white(), for: .normal)
        counterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        buttonStack.addArrangedSubview(counterButton)
        counterButton.rx.tap.bind { [weak self] in
            vc.removeFromParentVC()
            self?.incomingBidCellDidClickCounter(cell, buttonView: buttonView)
        }.disposed(by: bag)
        counterButton.setHeightAnchor(48)

        buttonStack.distribution = .fillEqually
        vc.buttonContainer.addSubview(buttonStack)
        buttonStack.pinToAllEdges(of: vc.buttonContainer)
    }

    func incomingBidCellDidClickCounter(_ cell: WPIncomingBidCell, buttonView: UIView) {
        let minBidText = viewModel.minBid?.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true) ?? ""
        let bidId = cell.bidId
        showNewBid(minBidText: minBidText, bidToReject: bidId, cell: cell, buttonView: buttonView, onClose: nil)
    }

    typealias BidCloseClosure = (() -> Void)
    private func showNewBid(minBidText: String,
                            bidToReject: UUID?,
                            cell: MSGMessageCell,
                            buttonView: UIView,
                            tag: Int? = nil,
                            onClose: BidCloseClosure? = nil) {
        let config = ChatDialogConfig(color: R.color.shinyBlue()!,
                                      icon: R.image.chatCellNewIcon(),
                                      title: R.string.localizable.chatCellDialogCounterBidTitle(),
                                      description: R.string.localizable.chatCellDialogCounterBidDescription())
        let vc = getChatDialog(config: config,
                               cell: cell,
                               buttonView: buttonView,
                               tag: tag) { vc in
            vc.removeFromParentVC()
            onClose?()
        }
        let verticalStack = ViewFactory.createVerticalStack(spacing: 8)
        let buttonStack = ViewFactory.createHorizontalStack(spacing: 8)
        let bidTextfield = ViewFactory.createTextField(placeholder: R.string.localizable.chatCellDialogCounterBidPlaceholder())
        buttonStack.addArrangedSubview(bidTextfield)

        let errorText = R.string.localizable.chatCellDialogCounterBidMinBidError(minBidText)
        let errorLabel = ViewFactory.createLabel(text: errorText, font: .descriptionText)
        errorLabel.textColor = .redInvalid
        errorLabel.isHidden = true

        bidTextfield.setHeightAnchor(48)

        let placeButton = ViewFactory.createPrimaryButton(text: R.string.localizable.chatCellDialogCounterBidButton(),
                                                          style: .shinyBlue)
        placeButton.isEnabled = false

        let bidIsValidObs = bidTextfield.rx.text.orEmpty
            .map { [weak self] text -> Bool in
                // Clear the error when the textfield is empty
                guard !text.isEmpty else { return true }
                return self?.viewModel.isValidBidPrice(text: text) ?? false
            }
        bidIsValidObs.bind(to: errorLabel.rx.isHidden).disposed(by: bag)
        bidIsValidObs.map { !$0 }.bind(to: bidTextfield.rx.error).disposed(by: bag)

        bidTextfield.rx.text.map { [weak self] _ -> Bool in
            self?.viewModel.isValidBidPrice(text: bidTextfield.text) ?? false
        }.bind(to: placeButton.rx.isEnabled).disposed(by: bag)

        buttonStack.addArrangedSubview(placeButton)
        placeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.viewModel.isValidBidPrice(text: bidTextfield.text) else { return }
            guard let amount = bidTextfield.text?.getPrice() else { return }
            self.viewModel.doBid(amount: amount).subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    vc.removeFromParentVC()
                    if let bidToReject = bidToReject {
                        self.viewModel.onBidAction(id: bidToReject, accepted: false)
                    }

                    self.viewModel.onBidCountered()
                    onClose?()
                case let .failure(error):
                    vc.removeFromParentVC()
                    self.showError(error)
                    onClose?()
                }
            }).disposed(by: self.bag)
        }.disposed(by: bag)
        placeButton.setHeightAnchor(48)

        buttonStack.distribution = .fillEqually
        verticalStack.addArrangedSubview(buttonStack)
        buttonStack.pinToEdges(of: verticalStack, orientation: .horizontal)
        verticalStack.addArrangedSubview(errorLabel)
        errorLabel.pinToEdges(of: verticalStack, orientation: .horizontal)
        vc.buttonContainer.addSubview(verticalStack)
        verticalStack.pinToAllEdges(of: vc.buttonContainer)
    }
}

// MARK: UICollectionViewDataSource

extension ChatViewController {
    override func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section == 0 else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
        UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let identifier = WPChatCollectionView.chatHeaderIdentifier
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
            guard let header = headerView as? WPChatCollectionViewHeader else {
                return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
            }
            viewModel.outputs.chatHeaderTitle.bind(to: header.title.rx.text).disposed(by: bag)
            viewModel.outputs.chatHeaderTitle.map { !$0.isEmpty }.subscribe(onNext: { [weak header] vis in
                header?.stackView.arrangedSubviews.forEach { $0.isVisible = vis }
            }).disposed(by: bag)
            viewModel.outputs.chatHeaderDate.bind(to: header.date.rx.text).disposed(by: bag)

            return headerView
        case UICollectionView.elementKindSectionFooter:
            let cell = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
            if let footer = cell as? WPCollectionViewSectionFooter {
                footer.isRead = viewModel.isSectionRead(indexPath.section)
            }
            return cell
        default: break
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

// MARK: WPOrderIncompleteCellDelegate

extension ChatViewController: WPOrderIncompleteCellDelegate, WPOutgoingBidCellDelegate {
    func orderIncompleteBidPressed(cell: WPOrderIncompleteCell, buttonView: UIView, reloadMessages: Bool) {
        guard let orderId = cell.orderId else { return }
        orderIncompleteDialogExpanded.setValue(forKey: orderId, value: true)
        if reloadMessages {
            self.reloadMessages()
        }
        let minBidText = viewModel.minBid?.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true) ?? ""
        showNewBid(minBidText: minBidText, bidToReject: nil, cell: cell, buttonView: buttonView, onClose: { [weak self] in
            orderIncompleteDialogExpanded.setValue(forKey: orderId, value: false)
            self?.reloadMessages()
        })
    }

    func outgoingBidBidPressed(cell: WPOutgoingBidCell, buttonView: UIView, reloadMessages: Bool) {
        guard let bidId = cell.bidId else { return }
        outgoingBidDialogExpanded.setValue(forKey: bidId, value: true)
        if reloadMessages {
            self.reloadMessages()
        }
        let minBidText = viewModel.minBid?.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true) ?? ""
        showNewBid(minBidText: minBidText,
                   bidToReject: nil,
                   cell: cell,
                   buttonView: buttonView,
                   tag: WPOutgoingBidCell.OutgoingBidDialogTag,
                   onClose: { [weak self] in
                       outgoingBidDialogExpanded.setValue(forKey: bidId, value: false)
                       self?.reloadMessages()
        })
    }
}

extension ChatViewController: WPMediaCellDelegate, LightboxControllerDismissalDelegate {
    func didTapMedia(payload: MediaPayload) {
        switch payload.type {
        case .image:
            var fullImage: LightboxImage?
            switch payload.data {
            case let .existing(url):
                fullImage = LightboxImage(imageURL: url)
            case let .local(data):
                guard let image = UIImage(data: data) else { return }
                fullImage = LightboxImage(image: image)
            }
            guard let image = fullImage else { return }
            let controller = WPChatLightboxController(images: [image], startIndex: 0)
            controller.dynamicBackground = true
            controller.dismissalDelegate = self
            controller.modalPresentationStyle = UIDevice.current.userInterfaceIdiom != .pad ? .fullScreen : .currentContext
            let nav = WhoppahNavigationController(rootViewController: controller)
            nav.isNavigationBarHidden = true
            nav.isModalInPresentation = true
            if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
            present(nav, animated: true, completion: nil)
        case .video:
            switch payload.data {
            case let .existing(url):
                let videoController = AVPlayerViewController()
                videoController.player = AVPlayer(url: url)

                present(videoController, animated: true) {
                    videoController.player?.play()
                }
            case .local:
                assertionFailure("Implement this")
            }
        }
    }

    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
}

class WPChatLightboxController: LightboxController {
    override var shouldAutorotate: Bool {
        true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIInterfaceOrientationMask.all
    }
}

// MARK: TLPhotosPickerViewControllerDelegate

extension ChatViewController: TLPhotosPickerViewControllerDelegate {
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
         guard !withPHAssets.isEmpty else { return }
         let manager = PHImageManager()
         manager.fetchImages(assets: withPHAssets, imageFetched: nil) { images in
             guard let image = images.first else { return }
             DispatchQueue.global().async {
                 let scaledImage = image.scaledToMaxWidth(1000)
                 guard let photo = scaledImage.jpegData(compressionQuality: 0.8) else { return }
                 DispatchQueue.main.async {
                     self.sendMessage("", image: photo)
                 }
             }
         }
     }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        let alertController = UIAlertController(title: "",
                                                message: R.string.localizable.select_photos_max_exceeded("1"),
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: R.string.localizable.merchant_profile_incomplete_dialog_ok_button(),
                                   style: .cancel, handler: nil)
        alertController.addAction(action)
        picker.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        DispatchQueue.global().async {
            let scaledImage = image.scaledToMaxWidth(1000)
            guard let photo = scaledImage.jpegData(compressionQuality: 0.8) else { return }
            DispatchQueue.main.async {
                self.sendMessage("", image: photo)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
