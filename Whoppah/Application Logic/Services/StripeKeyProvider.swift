//
//  StripeKeyProvider.swift
//  Whoppah
//
//  Created by Eddie Long on 10/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import Stripe
import WhoppahCore
import Resolver

class StripeKeyProvider: NSObject, STPCustomerEphemeralKeyProvider {
    private let bag = DisposeBag()
    
    @Injected private var payment: PaymentService

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        payment.getEphemeralKey(sdkVersion: apiVersion).subscribe(onNext: { key in
            completion(key as [AnyHashable: Any], nil)
        }, onError: { error in
            completion(nil, error)
        }).disposed(by: bag)
    }
}
