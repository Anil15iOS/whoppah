//
//  ChatViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 25/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import DifferenceKit
import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

enum ChatError: String, Error, LocalizedError {
    case noTargetSubscriberFound = "no valid user to target for a counter bid"

    public var errorDescription: String? {
        switch self {
        default:
            #if DEBUG || STAGING || TESTING
                return rawValue
            #else
                return R.string.localizable.common_generic_error_message()
            #endif
        }
    }
}

typealias ChangesetApplied = (() -> Void)
typealias OldSections = [ArraySection<Int, Int>]
typealias NewSections = [ArraySection<Int, Int>]
typealias ChangesetMediator = ((OldSections, NewSections, ChangesetApplied) -> Void)

class ChatViewModel {
    @Injected fileprivate var crashReporter: CrashReporter
    
    var messages: [ChatMessage] = []
    var sections: [[Int]] = []
    private var processingMediaItems = [UUID: Int]()
    private var deliveryData: DeliveryUIData?

    typealias MessageId = Int
    // To find a message in our multi-dimensional array it can potentially take O(n)
    // To quicken this up (for refreshes especially) we store the messageID -> IndexPath
    var messagePathMap = [MessageId: IndexPath]()
    var thread: GraphQL.GetThreadQuery.Data.Thread?

    var myUser: ChatUser?

    var onSendMessage: ((String) -> Void)?

    let coordinator: ChatCoordinator
    private let threadRepo: ThreadRepository
    private let messageRepo: ThreadMessageRepository
    private let bag = DisposeBag()
    private let messageFactory: ChatMessageFactory
    private static let dateFormatter = DateFormatter()
    
    @Injected fileprivate var inAppNotifier: InAppNotifier
    @Injected fileprivate var eventTrackingService: EventTrackingService
    @Injected fileprivate var auctionService: AuctionService
    @Injected fileprivate var mediaService: MediaService
    @Injected fileprivate var chatService: ChatService
    @Injected fileprivate var userService: WhoppahCore.LegacyUserService
    @Injected fileprivate var paymentService: PaymentService

    struct Outputs {
        var showReviewRequest: Observable<Void> { _showReviewRequest.asObservable() }
        fileprivate let _showReviewRequest = PublishRelay<Void>()

        var threadLoaded: Observable<Void> { _threadLoaded.compactMap { $0 } }
        fileprivate let _threadLoaded = BehaviorRelay<Void?>(value: nil)

        var error: Observable<Error> { _error.asObservable() }
        fileprivate let _error = PublishRelay<Error>()

        var chatHeaderTitle: Observable<String> { _chatHeaderTitle.asObservable() }
        fileprivate let _chatHeaderTitle = BehaviorRelay<String>(value: "")

        var chatHeaderDate: Observable<String> { _chatHeaderDate.asObservable() }
        fileprivate let _chatHeaderDate = BehaviorRelay<String>(value: "")

        var fetchMessages: Observable<Bool> { _fetchMessages.asObservable() }
        fileprivate let _fetchMessages = PublishRelay<Bool>()

        var reloadMessages: Observable<Void> { _reloadMessages.asObservable() }
        fileprivate let _reloadMessages = PublishRelay<Void>()
    }

    let outputs = Outputs()
    var paginator: PagedView {
        messageRepo.paginator
    }

    init(coordinator: ChatCoordinator,
         threadRepo: ThreadRepository,
         messageRepo: ThreadMessageRepository) {
        self.coordinator = coordinator
        self.threadRepo = threadRepo
        self.messageRepo = messageRepo
        messageFactory = ChatMessageFactory()
        ChatViewModel.dateFormatter.dateStyle = .short
        ChatViewModel.dateFormatter.doesRelativeDateFormatting = true

        threadRepo.thread
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.thread = data

                if let product = data.item.asProduct {
                    self.deliveryData = self.createDeliveryData(product)
                }

            }).disposed(by: bag)

        threadRepo.thread
            .compactMap { $0 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setupSubscribers()
                self.setupNotifications()
                self.setupChatThreadHeader()
                self.outputs._threadLoaded.accept(())
            }).disposed(by: bag)
    }

    deinit {
        clearChatCellProperties()
    }

    // MARK: Public functions

    func isSectionRead(_ section: Int) -> Bool {
        if let last = sections[section].last {
            let message = messages[last]
            return !message.isUnread
        }
        return true
    }

    func sectionFooterTitle(_ section: Int) -> String? {
        if let last = sections[section].last {
            let message = messages[last]
            return message.msgMessage.sentAt.getReadableDate()
        }
        return nil
    }

    func onBidAction(amount: Double, accepted: Bool) {
        if let thread = thread, let product = thread.item.asProduct {
            eventTrackingService.trackBidStatusChanged(receiverID: product.merchant.id,
                                                adID: product.id,
                                                conversationID: thread.id,
                                                bidValue: Int(amount),
                                                bidStatus: accepted ? "accepted" : "rejected")
        }
    }

    func onBidCountered() {
        outputs._fetchMessages.accept(true)
    }

    func onBidAction(id: UUID, accepted: Bool) {
        if accepted {
            auctionService.acceptBid(id: id)
                .subscribe(onNext: { [weak self] bid in
                    guard let self = self else { return }
                    self.onBidAction(amount: bid.price.amount, accepted: accepted)
                    self.outputs._fetchMessages.accept(true)
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error,
                                           withInfo: ["screen": "chat", "type": "accept_bid"])
                    self?.coordinator.showError(error)
                }).disposed(by: bag)
        } else {
            auctionService.rejectBid(id: id)
                .subscribe(onNext: { [weak self] bid in
                    guard let self = self else { return }
                    self.onBidAction(amount: bid.price.amount, accepted: accepted)
                    self.outputs._fetchMessages.accept(true)
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "chat", "type": "reject_bid"])
                    self?.coordinator.showError(error)
                }).disposed(by: bag)
        }
    }

    func onAvatarTapped(_ user: ChatUser) {
        guard !user.isBot() else { return }
        coordinator.openProfile(user.id)
    }

    func load(fetchLatest: Bool = false, reloadCallback: (() -> Void)? = nil, callback: @escaping ChangesetMediator) {
        let touchMessages = fetchLatest || messageRepo.paginator.isFirstPage()
        messageRepo.load(fetchLatest: fetchLatest)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(newMessages):
                    self.onMessagesFetched(newMessages,
                                           fetchLatest: fetchLatest,
                                           callback: callback)
                    if touchMessages {
                        self.messageRepo.touch()
                            .subscribe(onError: { [weak self] error in
                                self?.crashReporter.log(error: error,
                                                        withInfo: ["screen": "chat", "type": "touch"])
                            }, onCompleted: { [weak self] in
                                self?.updateUnreadCountBadge()
                            })
                            .disposed(by: self.bag)
                    }
                case let .failure(error):
                    self.outputs._error.accept(error)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }

                self.crashReporter.log(error: error,
                                       withInfo: ["screen": "chat", "type": "load_messages"])
                self.outputs._error.accept(error)
            }).disposed(by: bag)
    }

    func openPayment(bidId: UUID, orderId: UUID?) {
        guard let product = thread?.item.asProduct else { return }
        let paymentInput = PaymentInput(productId: product.id, bidId: bidId, orderId: orderId)
        coordinator.openPayment(input: paymentInput, isBuyNow: false, delegate: self)
    }

    private func addProcessingMediaItem(id: UUID, messageId: Int, callback: @escaping ChangesetMediator) {
        DispatchQueue.main.async {
            self.processingMediaItems[id] = messageId

            self.load(fetchLatest: true, callback: callback)
        }
    }

    func sendMessage(_ text: String, image: Data?, video: Data?, callback: @escaping ChangesetMediator) {
        guard let thread = thread else { return }
        guard image == nil else {
            var user = myUser!
            user.isSender = true
            let message = messageFactory.createMediaMessage(id: UUID(), user: user, mediaId: UUID(), mediaData: image!, mediaType: .image)
            insert(message, callback: callback)

            mediaService.uploadImage(data: image!, contentType: .message, objectId: thread.id, type: nil, position: nil)
                .subscribe(onNext: { [weak self] state in
                    switch state {
                    case let .complete(imageId):
                        self?.addProcessingMediaItem(id: imageId, messageId: message.id, callback: callback)
                    case .progress:
                        break
                    }
                }, onError: { [weak self] error in
                    self?.coordinator.showError(error)
                }).disposed(by: bag)
            return
        }

        guard video == nil else {
            var user = myUser!
            user.isSender = true
            let message = messageFactory.createMediaMessage(id: UUID(), user: user, mediaId: UUID(), mediaData: video!, mediaType: .image)
            insert(message, callback: callback)

            mediaService.uploadVideo(data: video!, contentType: .message, objectId: thread.id, position: nil)
                .subscribe(onNext: { [weak self] state in
                    switch state {
                    case let .complete(videoId):
                        self?.addProcessingMediaItem(id: videoId, messageId: message.id, callback: callback)
                    default:
                        break
                    }
                }, onError: { [weak self] error in
                    self?.coordinator.showError(error)
                }).disposed(by: bag)
            return
        }
        chatService.sendChatMessage(id: thread.id, text: text)
            .subscribe(onNext: { [weak self] result in
                guard let self = self, var user = self.myUser else { return }
                user.isSender = true
                let message = self.messageFactory.createTextMessage(result, user: user)
                self.insert(message, callback: callback)

                // Refresh messages
                self.load(fetchLatest: true, callback: callback)

                if let product = thread.item.asProduct {
                    self.eventTrackingService.trackSendMessage(receiverID: product.merchant.id,
                                                                 adID: product.id,
                                                                 conversationID: thread.id,
                                                                 counterBid: nil,
                                                                 textMessage: true,
                                                                 isPDPQuestion: false)
                }

            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "chat", "type": "message_send"])
                self?.outputs._error.accept(error)
            }).disposed(by: bag)
    }

    var minBid: PriceInput? {
        guard let minBid = thread?.item.asProduct?.auction?.minimumBid else { return nil }
        return PriceInput(currency: minBid.currency, amount: minBid.amount)
    }

    func isValidBidPrice(text: String?) -> Bool {
        guard let minBid = minBid else { return false }
        guard let priceText = text?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted) else { return false }
        guard let number = Money(priceText) else { return false }
        return number >= minBid.amount
    }

    // MARK: Privates
    
    private func createDeliveryData(_ product: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct) -> DeliveryUIData
    {
        let deliveryDetails = getDeliveryDetails(product)
        let pickupDetails = getPickUpDetails(product)
        
        return DeliveryUIData(delivery: deliveryDetails,
                              pickUp: pickupDetails)
    }
    
    private func getDeliveryDetails(_ ad: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct) -> AdDelivery {
        var deliveryCost = R.string.localizable.ad_details_delivery_pickup_price()
        var method = ""
        var description = ""
        var type = "unknown"

        if ad.deliveryMethod == .pickup {
            return AdDelivery(method: method, description: description, type: type, price: deliveryCost)
        }

        if let shipping = ad.shippingMethod {
            deliveryCost = ad.shippingCost.amount.formattedPrice(showFraction: true, currency: ad.shippingCost.currency)
            type = shipping.slug.capitalizingFirstLetter()
        }

        method = localizedString("product-shipping-\(type)-title") ?? R.string.localizable.ad_details_delivery_title()

        if let localizedDescription = localizedString("product-shipping-\(type)-description") {
            description = String(format: localizedDescription, deliveryCost)
        } else {
            description = R.string.localizable.ad_details_delivery_title()
        }
        return AdDelivery(method: method, description: description, type: type, price: deliveryCost)
    }
    
    private func getPickUpDetails(_ ad: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct) -> AdPickup {
        if ad.deliveryMethod == .delivery && ad.shippingMethod?.slug != "custom"{
            return AdPickup(description: "", price: "")
        }
        let deliveryCost = R.string.localizable.ad_details_delivery_pickup_price()

        return AdPickup(description: localizedString("product-shipping-pickup") ?? "", price: deliveryCost)
    }
    
    private func showAutoreplyForTheFirstMessage(_ chatMessages: [GraphQL.GetMessagesQuery.Data.Message.Item]) -> Bool {
        
        guard let thread = thread else { return false }
       
        let replyMessage = messages.first { message -> Bool in
            switch message.type {
            case .firstReply:
                return true
            default:
                return false
            }
        }
        guard replyMessage == nil else { return false }
        
        if chatMessages.count == 1,
           let firstMessage = chatMessages.first,
           let firstMessageSenderId = chatMessages.first?.sender.id {
            // only one message in the thread
            
            if firstMessage.body != nil {
                // first message is text
                
                let isFirstMessageByUser = firstMessageSenderId == userService.current?.id

                if isFirstMessageByUser {
                    // first message is sent by me

                    if let threadMerchantId = thread.item.asProduct?.merchant.id,
                       let userMerchantId = userService.current?.merchant.first?.id,
                       threadMerchantId != userMerchantId {
                        // I am not the seller
                        return true
                    }
                }
            }
        }
        
        return false
    }

    private func onMessagesFetched(_ chatMessages: [GraphQL.GetMessagesQuery.Data.Message.Item],
                                   fetchLatest: Bool,
                                   callback: ChangesetMediator) {
        guard let thread = thread else { return }
        let snapshot = getSectionArray(withInput: sections)

        var newMessages = [ChatMessage]()
        var messagesToRemove = Set<Int>() // No duplicates allowed
        guard let myMember = userService.current else { return }

        let showAutoreplyToTheFirstMessage = showAutoreplyForTheFirstMessage(chatMessages)
        
        for newMessage in chatMessages {
            let messageMerchant = newMessage.merchant
            let isSender = myMember.merchantId == messageMerchant.id
            var user: ChatUser!
            if isSender {
                user = myUser
            } else {
                let name = getMerchantDisplayName(type: messageMerchant.type,
                                                  businessName: messageMerchant.businessName,
                                                  name: messageMerchant.name,
                                                  hideBusinessName: false)
                let avatar = URL(string: messageMerchant.avatar?.url ?? "")
                user = ChatUser(id: messageMerchant.id,
                                displayName: name,
                                avatarUrl: avatar,
                                role: newMessage.subscriber?.role)
            }

            user.isSender = isSender

            // First we find the existing messages that are associated with this message id
            // There can be >1 due to bot messages
            let existingAssociatedMessages = messageFactory.getMessageId(newMessage.id)
            // Next get the indices in the flat 'messages' array
            let existingIndices = existingAssociatedMessages.compactMap { messageId -> Int? in
                guard let path = self.getIndexPath(forMessageID: messageId) else { return nil }
                return self.sections[path.section][path.row]
            }

            // Clear up the message map so we don't get left with dead message ids
            messageFactory.removeMessages(forId: newMessage.id)

            let messageNewMessages = messageFactory.create(message: newMessage,
                                                           thread: thread,
                                                           user: user,
                                                           showsAutoreply: showAutoreplyToTheFirstMessage)

            // If the buyer/seller has completed the order then this is a pretty good time to ask for a review
            if let order = newMessage.item?.asOrder, order.orderState == .completed {
                outputs._showReviewRequest.accept(())
            }

            // Prepend messages
            // We receive back from the server newest first but we want to display newest last in terms of the list view
            newMessages = messageNewMessages + newMessages

            // Remove any local media that has been completed
            if let mediaId = messageFactory.getMediaId(newMessage), let messageIndex = processingMediaItems[mediaId] {
                if let path = getIndexPath(forMessageID: messageIndex) {
                    let index = sections[path.section][path.row]
                    messagesToRemove.insert(index)
                }
            }

            // Remove messages that were there before
            // We just re-add in the messages again.
            // Could just calculate which have been removed and only remove those
            // However there becomes ordering issues in this case
            // Easier to just remove all previous messages
            messagesToRemove = messagesToRemove.union(existingIndices)
        }

        // Make sure we have descending order so we can remove from the array correctly
        let desOrder = messagesToRemove.sorted(by: { $0 > $1 })
        for messageToRemove in desOrder {
            messages.remove(at: messageToRemove)
        }
    
        let addToBottom = messageRepo.paginator.isFirstPage() || fetchLatest
        var rowIndex = addToBottom ? messages.count : 0
        for message in newMessages {
            addMessage(message, atIndex: rowIndex)
            rowIndex += 1
        }

        update(sectionSnapshot: snapshot,
               callback: callback)
    }

    private func updateUnreadCountBadge() {
        guard let threadId = thread?.id else { return }
        inAppNotifier.notify(.chatMessagesRead, userInfo: ["thread_id": threadId])
    }

    private func setupSubscribers() {
        // Only set up the users once
        if myUser == nil, let myMember = userService.current {
            let myMerchant = myMember.mainMerchant
            let myName = getMerchantDisplayName(type: myMerchant.type,
                                                businessName: myMerchant.businessName,
                                                name: myMerchant.name,
                                                hideBusinessName: false)

            let myAvatar = URL(string: myMerchant.avatarImage?.url ?? "")
            // Must be a subscriber to be seeing the chat
            myUser = ChatUser(id: myMerchant.id,
                              displayName: myName,
                              avatarUrl: myAvatar,
                              role: .subscriber)
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(chatMessageHandler(_:)), name: PushNotifications.Name.chat, object: nil)
    }

    private func setupChatThreadHeader() {
        guard let thread = thread else { return }
        guard let myUser = myUser else { return }
        let otherSubscribers = thread.subscribers.filter { $0.merchant.id != myUser.id }
        guard let firstSubscriber = otherSubscribers.first else { return }
        let subscriberName = getMerchantDisplayName(type: firstSubscriber.merchant.type,
                                                    businessName: firstSubscriber.merchant.businessName,
                                                    name: firstSubscriber.merchant.name,
                                                    hideBusinessName: false)

        if let product = thread.item.asProduct {
            if myUser.id == product.merchant.id {
                outputs._chatHeaderTitle.accept(R.string.localizable.chatHeaderProductBuyer(subscriberName))
            } else {
                let merchantName = getMerchantDisplayName(type: product.merchant.type,
                                                          businessName: product.merchant.businessName,
                                                          name: product.merchant.name,
                                                          hideBusinessName: false)
                outputs._chatHeaderTitle.accept(R.string.localizable.chatHeaderProductSeller(merchantName))
            }
        } else {
            let subscriberList = otherSubscribers.map { getMerchantDisplayName(type: $0.merchant.type,
                                                                               businessName: $0.merchant.businessName,
                                                                               name: $0.merchant.name) }
                .joined(separator: ", ")
            outputs._chatHeaderTitle.accept(R.string.localizable.chatHeaderDefault(subscriberList))
        }
        outputs._chatHeaderDate.accept(ChatViewModel.dateFormatter.string(from: thread.created.date))
    }

    private func update(sectionSnapshot: [ArraySection<Int, Int>],
                        callback: ChangesetMediator) {
        let newSections = regenerateSections()
        let new = getSectionArray(withInput: newSections)

        callback(sectionSnapshot, new) {
            self.sections = newSections
        }
    }

    private func getFirstBuyerBid() -> GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct.Auction.Bid? {
        guard let thread = thread, let auction = thread.item.asProduct?.auction else { return nil }
        let merchantId = userService.current?.merchantId

        // Ensure that there has been a bid from a buyer and that the buyer is one of the subscribers of this chat
        // (so we don't get other chat bids in here)
        // Merchant can only counter bid if there's been a bid from another subscriber
        // AND if the bid is not approved
        let subscribers = thread.subscribers.map { $0.merchant.id }
        // NOTE: Auction bids are across ALL users and threads, that's why they need to be filtered first by subscribers
        let subscriberBids = auction.bids.filter { $0.buyer.id != merchantId && subscribers.contains($0.buyer.id) }
        guard subscriberBids.first(where: { $0.state.isApproved() }) == nil else { return nil }

        return subscriberBids.first(where: { !$0.state.isApproved() })
    }
    
    private func regenerateSections() -> [[Int]] {
        var sections: [[Int]] = []
        messagePathMap.removeAll()
        var lastUser: UUID?
        // This will take o(log n), at best so does not scale well
        // But then this chat is not designed to be a full chat system
        messages.sort(by: { $0.sortDate().compare($1.sortDate()) == .orderedAscending })
        for (index, message) in messages.enumerated() {
            let messageUser = message.user.id
            if lastUser == nil || lastUser != messageUser {
                sections.append([index])
                messagePathMap[message.msgMessage.id] = IndexPath(row: 0, section: sections.count - 1)
            } else {
                let sectionIdx = sections.count - 1
                sections[sectionIdx].append(index)
                messagePathMap[message.msgMessage.id] = IndexPath(row: sections[sectionIdx].count - 1, section: sectionIdx)
            }
            lastUser = messageUser
        }
        #if DEBUG
            let flattened = sections.flatMap { $0 }
            assert(flattened.count == messages.count)
        #endif
        assert(messagePathMap.count == messages.count)
        return sections
    }

    private func addMessage(_ message: ChatMessage, atIndex index: Int? = nil) {
        if let index = index {
            messages.insert(message, at: index)
        } else {
            messages.append(message)
        }
    }

    private func getIndexPath(forMessageID messageID: MessageId) -> IndexPath? {
        messagePathMap.first(where: { $0.key == messageID })?.value
    }

    private func getSectionArray(withInput input: [[Int]]) -> [ArraySection<Int, Int>] {
        var sections = [ArraySection<Int, Int>]()
        for (index, section) in input.enumerated() {
            var items = [Int]()
            // Use the hash of each cell in the list
            // This is the best way to determine what has changed
            // Of course it depends on the implementation of the hashable protocol for the payloads
            for i in 0 ..< section.count {
                let flatIndex = input[index][i]
                assert(flatIndex < messages.count)
                items.append(messages[flatIndex].hash)
            }
            sections.append(ArraySection(model: index, elements: items))
        }
        return sections
    }

    private func insert(_ message: ChatMessage, callback: ChangesetMediator) {
        let snapshot = getSectionArray(withInput: sections)

        addMessage(message)

        let newSections = regenerateSections()
        let new = getSectionArray(withInput: newSections)
        callback(snapshot, new) {
            self.sections = newSections
        }
    }

    // MARK: Notification handlers

    @objc func chatMessageHandler(_ notification: Notification) {
        guard let data = notification.userInfo, let threadId = data[PushNotifications.ChatNotificationProp.thread] as? UUID else { return }
        guard threadId == thread?.id else { return }
        outputs._fetchMessages.accept(true)
    }
}

extension ChatViewModel {
    enum BidError: Error {
        case minPriceNotMet(minPrice: PriceInput)
    }

    func doBid(amount: Double) -> Observable<Result<Void, Error>> {
        let merchantId = userService.current!.mainMerchant.id
        return Observable.create { (observer) -> Disposable in

            guard let thread = self.thread else { observer.onCompleted(); return Disposables.create() }
            guard let product = thread.item.asProduct, let auction = product.auction else { observer.onCompleted(); return Disposables.create() }
            var currency = GraphQL.Currency.eur
            if let minBid = auction.minimumBid, amount < minBid.amount {
                currency = minBid.currency
                let price = PriceInput(currency: minBid.currency, amount: Double(minBid.amount.rounded(.up)))
                observer.onError(BidError.minPriceNotMet(minPrice: price))
                return Disposables.create()
            }

            let price = PriceInput(currency: currency, amount: amount)
            var obs: Observable<Bid>!
            if product.merchant.id == merchantId {
                var buyerId: UUID?
                if let existingBid = self.getFirstBuyerBid() {
                    buyerId = existingBid.buyer.id
                } else {
                    if thread.startedBy.id != merchantId {
                        buyerId = thread.startedBy.id
                    } else {
                        buyerId = thread.subscribers.first(where: { $0.merchant.id != merchantId })?.id
                    }
                }
                guard let buyer = buyerId else {
                    observer.onError(ChatError.noTargetSubscriberFound)
                    return Disposables.create()
                }
                obs = self.auctionService.createCounterBid(productId: product.id, auctionId: auction.id, amount: price, buyerId: buyer)
            } else {
                obs = self.auctionService.createBid(productId: product.id, auctionId: auction.id, amount: price, createThread: true)
            }

            obs.subscribe(onNext: { [weak self] bid in
                guard let self = self else { return }
                UserDefaultsConfig.onBidPlaced(bid.id)
                let eventTracking = self.eventTrackingService
                eventTracking.trackSendMessage(receiverID: product.merchant.id,
                                               adID: product.id,
                                               conversationID: thread.id,
                                               counterBid: bid.price.amount,
                                               textMessage: false,
                                               isPDPQuestion: false)

                observer.onNext(.success(()))
            }, onError: { [weak self] error in
                let threadID = thread.id
                let threadAdID = product.id
                
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "chat", "type": "bid_create", "thread_id": "\(threadID)", "thread_ad_id": "\(threadAdID)"])

                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
}

// MARK: - TrackCodeDialogDelegate

extension ChatViewModel: TrackCodeDialogDelegate, WPAskTrackingIDCellDelegate {
    func askTrackingIDCellDidClickTrack(orderId: UUID) {
        coordinator.openAskTrackingCode(self, orderId: orderId)
    }

    func trackCodeDialog(forOrder orderId: UUID, trackCode code: String) {
        paymentService.createShipment(orderId: orderId, trackingCode: code, returnsCode: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.outputs._fetchMessages.accept(true)
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "chat", "type": "createShipment"])
                self?.coordinator.showError(error)
            }).disposed(by: bag)
    }
}

// MARK: - DidReceiveProductCellDelegate

extension ChatViewModel: DidReceiveProductCellDelegate {
    private func sendFeedback(id: UUID, received: Bool, text: String? = nil) {
        paymentService.createFeedback(orderId: id, received: received, text: text)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if received {
                    self.onSendMessage?(R.string.localizable.chatReceivedGoodOrderMessage())
                } else {
                    self.outputs._fetchMessages.accept(true)
                }

                self.coordinator.openProductReceivedConfirmationDialog(received: received)
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "chat", "type": "createFeedback"])
                self?.coordinator.showError(error)
            }).disposed(by: bag)
    }

    func didReceiveProductGoodOrder(orderID: UUID) {
        receiveDialogVisibility.setValue(forKey: orderID, value: false)
        outputs._reloadMessages.accept(())
        sendFeedback(id: orderID, received: true)
    }

    func didReceiveProductNotGoodOrder(orderID: UUID) {
        receiveDialogVisibility.setValue(forKey: orderID, value: false)
        outputs._reloadMessages.accept(())
        sendFeedback(id: orderID, received: false)
    }

    func didReceiveProductToggleDialog(orderID: UUID, show: Bool) {
        receiveDialogVisibility.setValue(forKey: orderID, value: show)
        outputs._reloadMessages.accept(())
    }
    
    func showDeliveryInfo() {
        guard let deliveryData = deliveryData else { return }
        coordinator.showDeliveryInfo(data: deliveryData)
    }

    func showHowItWorks() {
        coordinator.showHowItWorks()
    }

}

extension ChatViewModel: PaymentDelegate, PaymentConfirmationDialogDelegate {
    func paymentConfirmationDialogDidTapDetailsButton(_: PaymentConfirmationDialog) {
        outputs._fetchMessages.accept(true)
        coordinator.dismiss(true)
    }

    func didFinishTransaction(input: PaymentInput, successful: Bool) {
        onPaymentComplete(input: input, successful: successful)
    }

    private func onPaymentComplete(input: PaymentInput, successful: Bool) {
        if successful {
            outputs._fetchMessages.accept(true)
        }

        if successful {
            coordinator.openPaymentCompletedDialog(self)
        } else {
            coordinator.openPaymentFailedDialog(input: input, isBuyNow: false, delegate: self)
        }
    }
}

// MARK: - WPAskPayCellDelegate

extension ChatViewModel: WPAskPayCellDelegate {
    func askPayCellDidClickBuy(payload: AskPayPayload) {
        openPayment(bidId: payload.bidId, orderId: payload.orderId)
    }
}

extension ChatViewModel: WPPaymentCompletedCellDelegate {
    func expandToggled(withOrderId orderId: UUID, andValue value: Bool) {
        orderDialogExpanded.setValue(forKey: orderId, value: value)
        outputs._reloadMessages.accept(())
    }
}
