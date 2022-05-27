//
//  AppDelegate+Injection.swift
//  Whoppah
//
//  Created by Dennis Ippel on 30/11/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import WhoppahDataStore
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerAppConfigurationProvider()
        registerWhoppahCoreServices()
        registerWhoppahDataStoreServices()
        registerLocalizers()
        
        lazy var appInitializables: AppInitializable = { AppInitializables() }()
        register { appInitializables }
        
        lazy var deeplinkables: Deeplinkable = { Deeplinkables() }()
        register { deeplinkables }
        
        lazy var deeplinkCoordinator: DeepLinkCoordinator = { DeepLinkCoordinator() }()
        register { deeplinkCoordinator }
        
        lazy var userRepository: LegacyUserRepository = { UserRepositoryImpl() }()
        register { userRepository }
        
        lazy var userProvider: UserProviding = { UserProvider() }()
        register { userProvider }
        
        lazy var shippingMethodsRepository: LegacyShippingMethodsRepository = { LegacyShippingMethodsRepositoryImpl() }()
        register { shippingMethodsRepository  }
        
        lazy var locationService: LocationService = { LocationServiceImpl() }()
        register { locationService }
        
        lazy var searchService: SearchService = { SearchServiceImpl() }()
        register { searchService }
        
        lazy var storeService: StoreService = { StoreServiceImpl() }()
        register { storeService }
        
        lazy var mediaCacheService: MediaCacheService = { MediaCacheServiceImpl() } ()
        register { mediaCacheService }
        
        lazy var permissionsService: PermissionsService = { PermissionsServiceImpl() }()
        register { permissionsService }
        
        lazy var cacheService: CacheService = { CacheServiceImpl() }()
        register { cacheService }
        
        lazy var featureService: FeatureService = { FeatureServiceImpl() }()
        register { featureService }
        
        lazy var httpService: HTTPServiceInterface = { HTTPService() }()
        register { httpService }
        
        lazy var recognitionService: RecognitionService = { RecognitionServiceImpl() }()
        register { recognitionService }
        
        lazy var userService: WhoppahCore.LegacyUserService = { UserServiceImpl() }()
        register { userService }
        
        lazy var apolloService: ApolloService = { ApolloServiceImpl() }()
        register { apolloService }
        
        lazy var adsService: ADsService = { ADsServiceImpl() }()
        register { adsService }
        
        lazy var auctionService: AuctionService = { AuctionServiceImpl() }()
        register { auctionService }
        
        lazy var paymentService: PaymentService = { PaymentServiceImpl() }()
        register { paymentService }
        
        lazy var chatService: ChatService = { ChatServiceImpl() }()
        register { chatService }
        
        lazy var languageTranslationService: LanguageTranslationService = { LanguageTranslationServiceImp() }()
        register { languageTranslationService }
        
        lazy var pushNotificationsService: PushNotificationsService = { PushNotificationsServiceImpl() }()
        register { pushNotificationsService }
        
        lazy var authenticationStore: AuthenticationStoring = { AuthenticationStore() }()
        register { authenticationStore }
        
        lazy var adCreator: ADCreator = { ADCreatorImpl() }()
        register { adCreator }
        
        lazy var mediaService: MediaService = { MediaServiceImpl() }()
        register { mediaService }
        
        lazy var merchantService: MerchantService = { MerchantServiceImpl() }()
        register { merchantService }
        
        #if DEBUG
        lazy var crashReporter: CrashReporter = { ConsoleCrashReporter() }()
        register { crashReporter }
        
        lazy var trackingService: EventTrackingService = { ConsoleEventTrackingService(enableLogging: true) }()
        register { trackingService }
        #else
        lazy var crashReporter: CrashReporter = { FirebaseCrashlyticsReporter() }()
        register { crashReporter }
        
        lazy var trackingService: EventTrackingService = { EventTrackingServiceImpl(segment: Segment()) }()
        register { trackingService }
        #endif
    }
}

