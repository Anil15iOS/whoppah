//
//  RegistrationViewHostingController+RegistrationInput.swift
//  Whoppah
//
//  Created by Dennis Ippel on 16/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahUI

extension RegistrationViewHostingController {
    struct RegistrationInput {
        struct BusinessInfo {
            var name = ""
            var contactFirstName = ""
            var contactLastName = ""
            var zipCode = ""
            var street = ""
            var additionalInfo = ""
            var country = ""
            var city = ""
        }
        
        var email = ""
        var password = ""
        var profileName = ""
        var givenName = ""
        var familyName = ""
        var phone = ""
        var address = AddressInput(merchantId: UUID(),
                                   line1: "",
                                   postalCode: "",
                                   city: "",
                                   country: "")
        var merchantType = MerchantType.individual
        var merchantName = ""
        var businessInfo = BusinessInfo()
        var socialSignUpId: RegistrationView.Model.SignUpOptionId? = nil
    }
}
