//
//  WhoppahDataStore+Injection.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 02/12/2021.
//

import Resolver
import WhoppahRepository

extension Resolver {
    public static func registerWhoppahDataStoreServices() {
        lazy var apolloService: ApolloService = { ApolloService() }()
        register { apolloService }

        lazy var apolloClient: ApolloServiceClient = { ApolloServiceClient() }()
        register { apolloClient }

        lazy var attributeRepository: AttributeRepository = { ApolloAttributeRepository() }()
        register { attributeRepository }

        lazy var authRepository: AuthRepository = { ApolloAuthRepository() }()
        register { authRepository }

        lazy var categoryRepository: CategoryRepository = { ApolloCategoryRepository() }()
        register { categoryRepository }

        lazy var merchantRepository: MerchantRepository = { ApolloMerchantRepository() }()
        register { merchantRepository }

        lazy var productRepository: ProductRepository = { ApolloProductRepository() }()
        register { productRepository }

        lazy var searchRepository: SearchRepository = { ApolloSearchRepository() }()
        register { searchRepository }

        lazy var userRepository: UserRepository = { ApolloUserRepository() }()
        register { userRepository }

        lazy var chatRepository: ChatRepository = { ApolloChatRepository() }()
        register { chatRepository }

        lazy var productDetailsRepository: ProductDetailsRepository = { ApolloProductDetailsRepository() }()
        register { productDetailsRepository }

        lazy var languageTranslationRepository: LanguageTranslationRepository = { ApolloLanguageTranslationRepository() }()
        register { languageTranslationRepository }

        lazy var shippingMethodsRepository: ShippingMethodsRepository = { ApolloShippingMethodsRepository() }()
        register { shippingMethodsRepository }

        lazy var auctionRepository: AuctionRepository = { ApolloAuctionRepository() }()
        register { auctionRepository }

        lazy var reviewsRepository: ReviewsRepository = { ApolloReviewsRepository() }()
        register { reviewsRepository }
        
        lazy var abuseRepository: AbuseRepository = { ApolloAbuseRepository() }()
        register { abuseRepository }

        lazy var productsRepository: ProductsRepository = { ApolloProductsRepository() }()
        register { productsRepository }
    }
}
