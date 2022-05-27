//
//  CoreServiceProvider.swift
//  WhoppahCore
//
//  Created by Eddie Long on 11/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

public protocol CoreServiceProvider: AnyObject {
    var ads: ADsService { get }
    var apollo: ApolloService { get }
    var auction: AuctionService { get }
    var auth: AuthService { get }
    var cache: CacheService { get }
    var chat: ChatService { get }
    var location: LocationService { get }
    var media: MediaService { get }
    var mediaCache: MediaCacheService { get }
    var merchant: MerchantService { get }
    var payment: PaymentService { get }
    var permissions: PermissionsService { get }
    var pushNotifications: PushNotificationsService { get set }
    var store: StoreService { get }
    var user: UserService { get set } // Mutable as the user itself needs to be mutable
}
