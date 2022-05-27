//
//  Member.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation

public enum MemberProfileError: Error {
    case missingCompanyName
    case missingProfileName
    case missingVat
    case missingAddress
    case missingPhone
}

public extension Member {
    // Temporary while switching between new and old architures. Will hold GraphQL object.
//    public var rawObject: AnyObject?
    
    var mainMerchant: Merchant? { merchants.first }
    var isProfessional: Bool {
        guard let mainMerchant = mainMerchant else {
            return false
        }
        return mainMerchant.type == .business
    }
    var merchantId: UUID? {
        guard let mainMerchant = mainMerchant else {
            return nil
        }
        return mainMerchant.id
    }
    
    var hasCompletedProfile: Result<Bool, MemberProfileError> {
        if isProfessional {
            // NOTE: 9/1/2019 - we cannot force a user to complete their profile if name is empty
            // This name is decided on sign up and we can't force users through the sign up flow again
            // Users can still go to My Whoppah but we want to bring the user through the same flow as sign up
            // guard !mainMerchant.name.isEmpty else { return .failure(.missingProfileName) }
            guard mainMerchant?.businessName?.isEmpty == false else { return .failure(.missingCompanyName) }
            // NOTE 6/5/2019 - users can enter in an address during checkout so we can proceed without a default address
            // guard company.addresses.first != nil else { return .failure(.missingAddress) }
            guard mainMerchant?.phone?.isEmpty == false else { return .failure(.missingPhone) }
            return .success(true)
        }

        // NOTE 6/5/2019 - users can enter in an address during checkout so we can proceed without a default address
        // guard addresses?.first != nil else { return .failure(.missingAddress) }
        return .success(true)
    }
}
