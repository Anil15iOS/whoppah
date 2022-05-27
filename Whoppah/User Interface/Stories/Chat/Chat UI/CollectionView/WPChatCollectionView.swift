//
//  WPChatCollectionView.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import MessengerKit

class WPChatCollectionView: MSGImessageCollectionView {
    static let chatHeaderIdentifier = "chatHeader"
    override func registerCells() {
        super.registerCells()

        register(UINib(nibName: "WPOutgoingTextCell", bundle: nil), forCellWithReuseIdentifier: "outgoingText")
        register(UINib(nibName: "WPIncomingTextCell", bundle: nil), forCellWithReuseIdentifier: "incomingText")

        register(UINib(nibName: "WPAutoresponseCell", bundle: nil), forCellWithReuseIdentifier: "autoresponse")
        register(UINib(nibName: "WPAskPayCell", bundle: nil), forCellWithReuseIdentifier: "askPay")
        register(UINib(nibName: "WPPaymentCompletedCell", bundle: nil), forCellWithReuseIdentifier: "paymentCompleted")
        register(UINib(nibName: "WPAskTrackingIDCell", bundle: nil), forCellWithReuseIdentifier: "askTrackingID")
        register(UINib(nibName: "WPTrackingIDCell", bundle: nil), forCellWithReuseIdentifier: "trackingID")
        register(UINib(nibName: "WPDidReceiveProductCell", bundle: nil), forCellWithReuseIdentifier: "didReceiveProductCell")
        register(UINib(nibName: "WPOrderIncompleteCell", bundle: nil), forCellWithReuseIdentifier: "orderIncompleteCell")

        register(UINib(nibName: "WPOutgoingBidCell", bundle: nil), forCellWithReuseIdentifier: "outgoingBid")
        register(UINib(nibName: "FirstAutoreplyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "autoreplyMessageIdentifier")
        register(UINib(nibName: "ItemReceivedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemReceivedCollectionViewCell")
        
        register(UINib(nibName: "WPIncomingBidCell", bundle: nil), forCellWithReuseIdentifier: "incomingBid")

        register(UINib(nibName: "WPOutgoingMediaCell", bundle: nil), forCellWithReuseIdentifier: "outgoingMedia")
        register(UINib(nibName: "WPIncomingMediaCell", bundle: nil), forCellWithReuseIdentifier: "incomingMedia")

        register(UINib(nibName: "WPChatCollectionViewHeader", bundle: nil),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WPChatCollectionView.chatHeaderIdentifier)
        register(UINib(nibName: "WPOutgoingSectionFooter", bundle: nil),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "outgoingFooter")
        register(UINib(nibName: "WPIncomingSectionFooter", bundle: nil),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "incomingFooter")
    }
}
