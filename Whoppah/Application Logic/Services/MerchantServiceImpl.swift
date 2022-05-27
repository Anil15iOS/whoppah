//
//  MerchantService.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/13/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class MerchantServiceImpl: MerchantService {
    
    @Injected private var apollo: ApolloService
    @Injected fileprivate var media: MediaService
    @Injected private var user: LegacyUserService
    
    private let bag = DisposeBag()
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAdLikeChanged(_:)), name: adLikeChange, object: nil)
    }

    @objc private func onAdLikeChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let id = userInfo[adIdObject] as? UUID else {
            return
        }
        guard let user = user.current else { return }
        let favoriteId = userInfo[adFavoriteId]
        let status = (favoriteId as? UUID) != nil
        if !status {
            let query = GraphQL.GetMerchantFavoritesQuery(id: user.mainMerchant.id, playlist: .hls)
            apollo.updateCache(query: query) { result in
                result.merchant?.favorites.removeAll(where: { $0.item.asProduct?.id == id })
            }
        }
    }

    func get(id: UUID) -> Observable<LegacyMerchantOther> {
        let input = GraphQL.GetMerchantQuery(id: id)
        return apollo.fetch(query: input).compactMap {
            $0.data?.merchant
        }
    }

    func update(_ merchant: LegacyMerchantInput) -> Observable<UUID> {
        let input = GraphQL.MerchantInput(type: merchant.type,
                                          name: merchant.name,
                                          biography: merchant.biography,
                                          url: merchant.url,
                                          phone: merchant.phone,
                                          email: merchant.email,
                                          businessName: merchant.businessName,
                                          taxId: merchant.taxId,
                                          vatId: merchant.vatId)
        let mutation = GraphQL.UpdateMerchantMutation(id: merchant.id, input: input)
        return apollo.apply(mutation: mutation).compactMap { $0.data?.updateMerchant.id }
    }

    func updateBankAccount(id: UUID, input: GraphQL.BankAccountInput) -> Observable<UUID> {
        let mutation = GraphQL.UpdateMerchantBankAccountMutation(id: id, input: input)
        return apollo.apply(mutation: mutation).compactMap { $0.data?.updateMerchantBankAccount.id }
    }
}

extension MerchantServiceImpl {
    private func setImageForType(id: UUID, data: Data, type: MerchantImageType, existing: UUID?) -> Observable<UUID> {
        let obs: Observable<UUID> = Observable.create { observer in
            self.media.uploadImage(data: data,
                                            contentType: GraphQL.ContentType.merchant,
                                            objectId: id,
                                            type: type.rawValue,
                                            position: nil)
                .subscribe(onNext: { state in
                    switch state {
                    case let .complete(imageId):
                        observer.onNext(imageId)
                        observer.onCompleted()
                    default:
                        break
                    }
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.bag)
            return Disposables.create()
        }

        guard let existing = existing else { return obs }
        return Observable.create { (observer) -> Disposable in
            // Always allow the user to upload a new image even if we fail to remove existing
            let obs = self.removeMedia(id: id, type: type, merchantId: existing).subscribe(onNext: { _ in
                obs.bind(to: observer).disposed(by: self.bag)
            }, onError: { _ in
                // Always allow the user to upload a new image
                obs.bind(to: observer).disposed(by: self.bag)
            })
            return Disposables.create {
                obs.dispose()
            }
        }
    }

    // MARK: - Avatar

    func setAvatar(id: UUID, data: Data, existing: UUID?) -> Observable<UUID> {
        setImageForType(id: id, data: data, type: .avatar, existing: existing)
    }

    func removeMedia(id: UUID, type: MerchantImageType, merchantId: UUID) -> Observable<Void> {
        media.deleteMerchantMedia(id: id, type: type, objectId: merchantId)
    }

    func setCover(id: UUID, data: Data, existing: UUID?) -> Observable<UUID> {
        setImageForType(id: id, data: data, type: .cover, existing: existing)
    }
}

extension MerchantServiceImpl {
    func report(id: UUID, reason: GraphQL.AbuseReportReason, comment: String) -> Observable<Void> {
        let input = GraphQL.AbuseReportInput(id: id, type: .user, reason: reason, description: comment)
        return apollo.apply(mutation: GraphQL.CreateAbuseReportMutation(input: input)).map { _ in () }
    }
}

extension MerchantServiceImpl {
    func addAddress(id: UUID, address: LegacyAddressInput) -> Observable<LegacyAddress> {
        let locationInput: GraphQL.LocationInput? = address.point != nil ? GraphQL.LocationInput(latitude: address.point!.latitude, longitude: address.point!.longitude) : nil
        let input = GraphQL.AddressInput(merchantId: id,
                                         line1: address.line1,
                                         line2: address.line2,
                                         postalCode: address.postalCode,
                                         city: address.city,
                                         state: address.state,
                                         country: address.country,
                                         location: locationInput)
        return apollo.apply(mutation: GraphQL.CreateAddressMutation(input: input),
                                     query: GraphQL.GetMeQuery(),
                                     storeTransaction: { (mutationResult, cachedQuery: inout GraphQL.GetMeQuery.Data) in
                                         guard let newAddress = mutationResult.data?.createAddress else { return }
                                         guard cachedQuery.me?.merchants.isEmpty == false else { return }
                                         var location: GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location?
                                         if let newLocation = newAddress.location {
                                             location = GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location(latitude: newLocation.latitude, longitude: newLocation.longitude)
                                         }
                                         let address = GraphQL.GetMeQuery.Data.Me.Merchant.Address(title: newAddress.title,
                                                                                                   id: newAddress.id,
                                                                                                   line1: newAddress.line1,
                                                                                                   line2: newAddress.line2,
                                                                                                   postalCode: newAddress.postalCode,
                                                                                                   city: newAddress.city,
                                                                                                   state: nil,
                                                                                                   country: newAddress.country,
                                                                                                   location: location)
                                         cachedQuery.me?.merchants[0].addresses.append(address)
        }).compactMap { $0.data?.createAddress }
    }

    func removeAddress(id _: UUID, addressId: UUID) -> Observable<Void> {
        apollo.apply(mutation: GraphQL.RemoveAddressMutation(id: addressId),
                              query: GraphQL.GetMeQuery(),
                              storeTransaction: { (_, cachedQuery: inout GraphQL.GetMeQuery.Data) in
                                  guard cachedQuery.me?.merchants.isEmpty == false else { return }
                                  cachedQuery.me?.merchants[0].addresses.removeAll(where: { $0.id == addressId })
        }).map { _ in () }
    }

    func updateAddress(id: UUID, address: LegacyAddressInput) -> Observable<LegacyAddress> {
        guard let addressId = address.id else {
            return addAddress(id: id, address: address)
        }
        let locationInput: GraphQL.LocationInput? = address.point != nil ? GraphQL.LocationInput(latitude: address.point!.latitude, longitude: address.point!.longitude) : nil
        let input = GraphQL.AddressInput(merchantId: id,
                                         line1: address.line1,
                                         line2: address.line2,
                                         postalCode: address.postalCode,
                                         city: address.city,
                                         state: address.state,
                                         country: address.country,
                                         location: locationInput)

        let query = GraphQL.GetMeQuery()
        return apollo.apply(mutation: GraphQL.UpdateAddressMutation(id: addressId, input: input),
                                     query: query,
                                     storeTransaction: { (mutationResult, cachedQuery: inout GraphQL.GetMeQuery.Data) in
                                         guard let newAddress = mutationResult.data?.updateAddress else { return }
                                         guard cachedQuery.me?.merchants.isEmpty == false else { return }
                                         var location: GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location?
                                         if let newLocation = newAddress.location {
                                             location = GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location(latitude: newLocation.latitude, longitude: newLocation.longitude)
                                         }
                                         let address = GraphQL.GetMeQuery.Data.Me.Merchant.Address(title: newAddress.title,
                                                                                                   id: newAddress.id,
                                                                                                   line1: newAddress.line1,
                                                                                                   line2: newAddress.line2,
                                                                                                   postalCode: newAddress.postalCode,
                                                                                                   city: newAddress.city,
                                                                                                   state: nil,
                                                                                                   country: newAddress.country,
                                                                                                   location: location)
                                         if let index = cachedQuery.me?.merchants[0].addresses.firstIndex(where: { $0.id == addressId }) {
                                             cachedQuery.me?.merchants[0].addresses[index] = address
                                         }
        }).compactMap { $0.data?.updateAddress }
    }
}
