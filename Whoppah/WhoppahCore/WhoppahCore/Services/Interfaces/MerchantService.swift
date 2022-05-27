//
//  MerchantService.swift
//  Whoppah
//
//  Created by Eddie Long on 11/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahDataStore

public protocol MerchantService {
    /// Fetches data for a given merchant
    ///
    /// - Parameter id The identifier for the merchant
    /// - Returns: An observable with the merchant data
    func get(id: UUID) -> Observable<LegacyMerchantOther>

    /// Updates the merchant data for the logged in user
    ///
    /// - Parameter merchant The updated merchant data
    /// - Returns: An observable with the updated merchant uuid
    func update(_ merchant: LegacyMerchantInput) -> Observable<UUID>

    /// Updates the bank account data for a given merchant ID
    /// Warning: Can only update the data for the current logged in user
    ///
    /// - Parameter id The merchant to update. NOTE: Must be the current logged in user
    /// - Parameter input The bank account data
    /// - Returns: An observable with the updated merchant uuid
    func updateBankAccount(id: UUID, input: GraphQL.BankAccountInput) -> Observable<UUID>

    /// Updates the avatar for a given merchant
    /// Warning: Can only update the data for the current logged in user
    ///
    /// - Parameter id The merchant to update. NOTE: Must be the current logged in user
    /// - Parameter data The raw image data
    /// - Parameter existing The existing avatar image id. Required so it can be deleted from the user so only one image remains active at a time
    /// - Returns: An observable with the updated merchant uuid
    func setAvatar(id: UUID, data: Data, existing: UUID?) -> Observable<UUID>

    /// Updates the cover for a given merchant
    /// Warning: Can only update the data for the current logged in user
    ///
    /// - Parameter id The merchant to update. NOTE: Must be the current logged in user
    /// - Parameter data The raw image data
    /// - Parameter existing The existing cover image id. Required so it can be deleted from the user so only one image remains active at a time
    /// - Returns: An observable with the updated merchant uuid
    func setCover(id: UUID, data: Data, existing: UUID?) -> Observable<UUID>

    /// Removes media for a given merchant
    /// Warning: Can only update the data for the current logged in user
    ///
    /// - Parameter id The identifier of the media to remove
    /// - Parameter type The 'type' of the image, e.g. 'cover' or 'avatar'
    /// - Parameter merchantId The merchant to update. NOTE: Must be the current logged in user
    /// - Returns: An observable with the updated merchant uuid
    func removeMedia(id: UUID, type: MerchantImageType, merchantId: UUID) -> Observable<Void>

    /// Reports a given merchant
    ///
    /// - Parameter id The identifier of the merchant to report
    /// - Parameter reason The abuse report reason
    /// - Parameter comment The comment to send alongside with the abuse report
    /// - Returns: An observable without any data
    func report(id: UUID, reason: GraphQL.AbuseReportReason, comment: String) -> Observable<Void>

    /// Add an address to a merchant
    ///
    /// - Parameter id The identifier of the merchant to add the address to
    /// - Parameter address The new address to add to the merchant
    /// - Returns: An observable with the newly created address data
    func addAddress(id: UUID, address: LegacyAddressInput) -> Observable<LegacyAddress>

    /// Remove an address from a merchant
    ///
    /// - Parameter id The identifier of the merchant
    /// - Parameter addressId The id of the address to remove from the merchant
    /// - Returns: An observable without any data
    func removeAddress(id: UUID, addressId: UUID) -> Observable<Void>

    /// Update the data for a given address
    ///
    /// - Parameter id The identifier of the merchant
    /// - Parameter address The new data for a given address
    /// - Returns: An observable with the updated address data
    func updateAddress(id: UUID, address: LegacyAddressInput) -> Observable<LegacyAddress>
}
