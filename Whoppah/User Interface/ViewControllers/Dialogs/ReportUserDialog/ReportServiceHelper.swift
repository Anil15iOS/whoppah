//
//  ReportUserService.swift
//  Whoppah
//
//  Created by Eddie Long on 12/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

struct ReportServiceHelper {
    @Injected private var merchantService: MerchantService
    @Injected private var adService: ADsService
    
    mutating func handleReportMerchantSend(merchantId: UUID,
                                  reason: GraphQL.AbuseReportReason,
                                  comment: String,
                                  vc: UIViewController) {
        _ = merchantService.report(id: merchantId, reason: reason, comment: comment).subscribe(onError: { error in
            vc.showError(error)
        })
    }

    mutating func handleReportProductSend(itemId: UUID,
                                 reason: GraphQL.AbuseReportReason,
                                 comment: String,
                                 vc: UIViewController) {
        _ = adService.reportItem(itemId: itemId, reason: reason, comment: comment).subscribe(onError: { error in
            vc.showError(error)
        })
    }
}
