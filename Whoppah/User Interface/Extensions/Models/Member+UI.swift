//
//  Member+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

extension LegacyMember {
    func getCharacterForAvatarIcon() -> Character? {
        guard !givenName.isEmpty else { return "-" }
        return givenName.uppercased()[givenName.startIndex]
    }
}

enum ProfileCompletionError: Error {
    case missingCompanyName
    case missingProfileName
    case missingVat
    case missingAddress
    case missingPhone
}

extension LegacyMember {
    func hasCompletedProfile() -> Result<Bool, ProfileCompletionError> {
        if isProfessional {
            // NOTE: 9/1/2019 - we cannot force a user to complete their profile if name is empty
            // This name is decided on sign up and we can't force users through the sign up flow again
            // Users can still go to My Whoppah but we want to bring the user through the same flow as sign up
            // guard !mainMerchant.name.isEmpty else { return .failure(.missingProfileName) }
            guard mainMerchant.businessName?.isEmpty == false else { return .failure(.missingCompanyName) }
            // NOTE 6/5/2019 - users can enter in an address during checkout so we can proceed without a default address
            // guard company.addresses.first != nil else { return .failure(.missingAddress) }
            guard mainMerchant.phone?.isEmpty == false else { return .failure(.missingPhone) }
            return .success(true)
        }

        // NOTE 6/5/2019 - users can enter in an address during checkout so we can proceed without a default address
        // guard addresses?.first != nil else { return .failure(.missingAddress) }
        return .success(true)
    }
}
