//
//  MerchantRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 19/01/2022.
//

import Combine
import Foundation
import WhoppahModel

public protocol MerchantRepository {
    func updateMerchant(_ merchant: MerchantInput) -> AnyPublisher<UUID, Error>
    func updateBankAccount(_ bankAccount: BankAccountInput, id: UUID) -> AnyPublisher<UUID, Error>
    func addAddress(_ address: AddressInput, id: UUID) -> AnyPublisher<Address, Error>
    func updateAddress(_ address: AddressInput, id: UUID) -> AnyPublisher<Address, Error>
    func removeAddress(id: UUID) -> AnyPublisher<Void, Error>
}
