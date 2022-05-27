//
//  MockServiceProvider.swift
//  WhoppahTests
//
//  Created by Eddie Long on 01/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

@testable import Testing_Debug
@testable import WhoppahCore
@testable import WhoppahCoreNext
@testable import WhoppahModel
@testable import WhoppahRepository
import Resolver

struct MockServiceInjector {
    static func register() {
        let mock = Resolver(child: Resolver.main)
        
        lazy var configuration: AppConfigurationProvider = { MockAppConfigService() }()
        mock.register { configuration }
        
        lazy var locationService: LocationService = { MockLocationService() }()
        mock.register { locationService }
        
        lazy var searchService: SearchService = { MockSearchService() }()
        mock.register { searchService }
        
        lazy var storeService: StoreService = { MockStoreService() }()
        mock.register { storeService }
        
        lazy var mediaCacheService: MediaCacheService = { MockMediaCacheService() } ()
        mock.register { mediaCacheService }
        
        lazy var permissionsService: PermissionsService = { MockPermissionService() }()
        mock.register { permissionsService }
        
        lazy var cacheService: CacheService = { MockCacheService() }()
        mock.register { cacheService }
        
        lazy var featureService: FeatureService = { MockFeatureService() }()
        mock.register { featureService }
        
        lazy var httpService: HTTPServiceInterface = { MockHttpService() }()
        mock.register { httpService }
        
        lazy var recognitionService: RecognitionService = { MockRecognitionService() }()
        mock.register { recognitionService }
        
        lazy var userService: WhoppahCore.LegacyUserService = { MockUserService() }()
        mock.register { userService }
        
        lazy var apolloService: ApolloService = { MockApolloService() }()
        mock.register { apolloService }
        
        lazy var adsService: ADsService = { MockAdService() }()
        mock.register { adsService }
        
        lazy var auctionService: AuctionService = { MockAuctionService() }()
        mock.register { auctionService }
        
        lazy var paymentService: PaymentService = { MockPaymentService() }()
        mock.register { paymentService }
        
        lazy var chatService: ChatService = { MockChatService() }()
        mock.register { chatService }
        
        lazy var languageTranslationService: LanguageTranslationService = { MockLanguageTranslationService() }()
        mock.register { languageTranslationService }
        
        lazy var pushNotificationsService: PushNotificationsService = { MockPushNotificationService() }()
        mock.register { pushNotificationsService }
        
        lazy var authRepository: AuthRepository = { MockAuthRepository() }()
        mock.register { authRepository }
        
        lazy var adCreator: ADCreator = { MockADCreator() }()
        mock.register { adCreator }
        
        lazy var mediaService: MediaService = { MockMediaService() }()
        mock.register { mediaService }
        
        lazy var merchantService: MerchantService = { MockMerchantService() }()
        mock.register { merchantService }
        
        lazy var eventTrackingService: EventTrackingService = { MockEventTrackingService() }()
        mock.register { eventTrackingService }
        
        lazy var crashReporter: CrashReporter = { ConsoleCrashReporter() }()
        mock.register { crashReporter }
        
        Resolver.root = mock
    }
}
