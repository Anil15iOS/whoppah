//
//  StripeInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import Stripe

struct StripeInitializer: AppInitializable {
    func didFinishLaunchingApplication() {
        #if TESTING || DEBUG
        StripeAPI.defaultPublishableKey = "pk_test_oCypG64KDGkVVo8K0c0cnGoO007UldPaSh"
        #else
        StripeAPI.defaultPublishableKey = "pk_live_VJvnCjSKovbVZRd7ep0NGOF300QBExU4IV"
        #endif
    }
}
