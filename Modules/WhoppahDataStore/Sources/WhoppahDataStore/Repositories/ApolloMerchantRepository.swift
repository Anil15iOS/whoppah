//
//  ApolloMerchantRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/01/2022.
//

import Foundation
import WhoppahRepository
import WhoppahModel
import Combine
import Resolver

struct ApolloMerchantRepository: MerchantRepository {
    @Injected private var apollo: ApolloService
    
    func updateMerchant(_ merchant: MerchantInput) -> AnyPublisher<UUID, Error> {
        guard let merchantId = merchant.id else {
            return Fail(outputType: UUID.self,
                        failure: WhoppahRepository.Error.missingParameter(named: "merchant.id"))
            .eraseToAnyPublisher()
        }
        
        let input = merchant.toGraphQLModel
        let mutation = GraphQL.UpdateMerchantMutation(id: merchantId,
                                                      input: input)
        return apollo.apply(mutation: mutation)
            .tryMap({ result -> UUID in
                guard let id = result.data?.updateMerchant.id else {
                    throw WhoppahRepository.Error.noData
                }
                return id
            })
            .eraseToAnyPublisher()
    }
    
    func updateBankAccount(_ bankAccount: BankAccountInput, id: UUID) -> AnyPublisher<UUID, Error> {
        let input = bankAccount.toGraphQLModel
        let mutation = GraphQL.UpdateMerchantBankAccountMutation(id: id,
                                                                 input: input)
        return apollo.apply(mutation: mutation)
            .tryMap({ result -> UUID in
                guard let id = result.data?.updateMerchantBankAccount.id else {
                    throw WhoppahRepository.Error.noData
                }
                return id
            })
            .eraseToAnyPublisher()
    }
    
    func addAddress(_ address: AddressInput, id: UUID) -> AnyPublisher<Address, Error> {
        var input = address.toGraphQLModel
        input.merchantId = id
        let mutation = GraphQL.CreateAddressMutation(input: input)
        
        return apollo.apply(mutation: mutation,
                            query: GraphQL.GetMeQuery(),
                            storeTransaction: { (mutationResult, cachedQuery: inout GraphQL.GetMeQuery.Data) in
            guard let newAddress = mutationResult.data?.createAddress,
                  cachedQuery.me?.merchants.isEmpty == false
            else { return }
            
            let address = GraphQL.GetMeQuery.Data.Me.Merchant.Address(newAddress)
            var merchantFirstAddress = cachedQuery.me?.merchants.first
            merchantFirstAddress?.addresses.append(address)
        })
        .tryMap { result -> Address in
            guard let address = result.data?.createAddress else {
                throw WhoppahRepository.Error.noData
            }
            return address.toWhoppahModel
        }
        .eraseToAnyPublisher()
    }
    
    func updateAddress(_ address: AddressInput, id: UUID) -> AnyPublisher<Address, Error> {
        guard let addressId = address.id else {
            return addAddress(address, id: id)
        }
        
        let input = address.toGraphQLModel
        let mutation = GraphQL.UpdateAddressMutation(id: addressId, input: input)
        
        return apollo.apply(mutation: mutation,
                            query: GraphQL.GetMeQuery(),
                            storeTransaction:  { (mutationResult, cachedQuery: inout GraphQL.GetMeQuery.Data) in
            guard let newAddress = mutationResult.data?.updateAddress,
                  cachedQuery.me?.merchants.isEmpty == false
            else { return }
            
            let address = GraphQL.GetMeQuery.Data.Me.Merchant.Address(newAddress)
            var firstMerchant = cachedQuery.me?.merchants.first
            
            if let index = firstMerchant?.addresses.firstIndex(where: { $0.id == addressId }) {
                firstMerchant?.addresses[index] = address
            }
        })
        .tryMap { result -> Address in
            guard let address = result.data?.updateAddress else {
                throw WhoppahRepository.Error.noData
            }
            return address.toWhoppahModel
        }
        .eraseToAnyPublisher()
    }
    
    func removeAddress(id: UUID) -> AnyPublisher<Void, Error> {
        let mutation = GraphQL.RemoveAddressMutation(id: id)
        return apollo.apply(mutation: mutation,
                            query: GraphQL.GetMeQuery(),
                            storeTransaction:  { (_, cachedQuery: inout GraphQL.GetMeQuery.Data) in
            guard cachedQuery.me?.merchants.isEmpty == false else { return }
            var firstMerchant = cachedQuery.me?.merchants.first
            firstMerchant?.addresses.removeAll(where: { $0.id == id })
        })
        .map({ _ in return () })
        .eraseToAnyPublisher()
    }
}
