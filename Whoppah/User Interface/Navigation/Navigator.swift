//
//  Navigator.swift
//  Whoppah
//
//  Created by Boris Sagan on 6/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore
import WhoppahModel
import WhoppahCoreNext
import WhoppahDataStore

class Navigator {
    struct AdRoutingData {
        let id: UUID
    }

    struct MyWhoppahRoutingData {
        enum Tab {
            case myAds(section: MyAdSection)
            case account(section: AccountSubsection)
        }

        enum MyAdSection {
            case ad(id: UUID)
            case none
        }

        enum AccountSubsection {
            case search(id: UUID?)
            case settings
            case contact
            case payment
            case myAds
            case none
        }

        let tab: Tab

        init(withAdID id: UUID) {
            tab = .myAds(section: MyAdSection.ad(id: id))
        }

        init(withMyAdSection section: MyAdSection) {
            tab = .myAds(section: section)
        }

        init(withSection section: AccountSubsection) {
            tab = .account(section: section)
        }
    }

    enum Route {
        case home
        case welcome
        case usp
        case map(latitude: Double?, longitude: Double?)
        case looks
        case search(input: SearchProductsInput)
        case searchByPhoto
        case createAd
        case browser(url: URL)

        case myWhoppah(data: MyWhoppahRoutingData)
        case finaliseAccount(userID: UUID, token: String)
        case resetPassword(userID: String, token: String)
        case profileCompletion
        case accountCreated

        case adDetails(data: AdRoutingData)
        case userProfile(id: UUID)

        case chat(threadID: UUID)
        case unknown

        static func ad(id: UUID) -> Route {
            Route.adDetails(data: AdRoutingData(id: id))
        }

        static func myWhoppahAd(id: UUID) -> Route {
            Route.myWhoppah(data: MyWhoppahRoutingData(withAdID: id))
        }
    }

    func navigate(route: Route) {
        navigatorRoute.onNext(route)
    }

    enum RoutePath: String {
        case address
        case welcome
        case paymentCompleted = "payment-completed"
        case resetPassword = "reset-password"
        case ad
        case search
        case usp
        case profile
        case map
        case looks
        case createAd = "create-ad"
        case myWhoppah = "my-whoppah"
        case chat
        case cart
        case howWorks = "how-whoppah-works"
    }

    enum MyWhoppahPaths: String, CaseIterable {
        case ad
        case account
        case accountSettings = "account-settings"
        case payment
        case contact
        case savedSearch = "saved-search"
    }

    static func getRoute(forUrl url: URL) -> Route {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return .unknown }
        let scheme = components.scheme
        let isWhoppah = (scheme == "whoppah")
        if !isWhoppah, scheme != "https", scheme != "http" { return .unknown }

        var path: String!
        if isWhoppah {
            guard let host = components.host else { return .unknown }
            path = host + components.path
        } else {
            path = components.path.stripPrefix("/")
        }

        let dict = components.queryItems?.compactMap { item -> (String, String)? in
            guard let value = item.value else { return nil }
            return (item.name, value)
        } ?? [(String, String)]()
        let arguments = Dictionary(dict, uniquingKeysWith: { first, _ in first })

        let items = components.queryItems
        let pathSections = path.components(separatedBy: "/")
        let remainingPath = pathSections.dropFirst().joined(separator: "/")
        switch pathSections.first ?? "" {
        case RoutePath.address.rawValue:
            guard
                let userIDValue = arguments["user"],
                let userID = UUID(uuidString: userIDValue) else { return .unknown }
            guard let token = arguments["key"] else { return .unknown }
            return .finaliseAccount(userID: userID, token: token)
        case RoutePath.createAd.rawValue, RoutePath.cart.rawValue:
            return .createAd
        case RoutePath.welcome.rawValue:
            guard let userIDItem = arguments["user"],
                let userID = UUID(uuidString: userIDItem) else { return .unknown }
            guard let token = arguments["key"] else { return .unknown }
            return .finaliseAccount(userID: userID, token: token)
        case RoutePath.myWhoppah.rawValue:
            switch remainingPath {
            case MyWhoppahPaths.ad.rawValue:
                guard let idItem = arguments["id"],
                    let id = UUID(uuidString: idItem) else { return .unknown }
                let data = MyWhoppahRoutingData(withAdID: id)
                return .myWhoppah(data: data)
            case MyWhoppahPaths.savedSearch.rawValue:
                var id: UUID?
                if let idItem = arguments["id"] {
                    id = UUID(uuidString: idItem)
                }
                let data = MyWhoppahRoutingData(withSection: .search(id: id))
                return .myWhoppah(data: data)
            case MyWhoppahPaths.account.rawValue:
                return .myWhoppah(data: MyWhoppahRoutingData(withSection: .none))
            case MyWhoppahPaths.accountSettings.rawValue:
                return .myWhoppah(data: MyWhoppahRoutingData(withSection: .settings))
            case MyWhoppahPaths.contact.rawValue:
                return .myWhoppah(data: MyWhoppahRoutingData(withSection: .contact))
            case MyWhoppahPaths.payment.rawValue:
                return .myWhoppah(data: MyWhoppahRoutingData(withSection: .payment))
            default: break
            }
        case RoutePath.chat.rawValue:
            guard let idItem = arguments["id"], let id = UUID(uuidString: idItem) else { return .unknown }
            return .chat(threadID: id)
        case RoutePath.paymentCompleted.rawValue:
            guard let threadIdItem = items?.filter({ $0.name == "thread_id" }).first,
                let threadIdValue = threadIdItem.value,
                let threadId = UUID(uuidString: threadIdValue) else { return .unknown }
            return .chat(threadID: threadId)
        case RoutePath.resetPassword.rawValue:
            guard let userID = arguments["uid"] else { return .unknown }
            guard let token = arguments["token"] else { return .unknown }
            return .resetPassword(userID: userID, token: token)
        case RoutePath.ad.rawValue:
            guard let idItem = arguments["id"],
                let id = UUID(uuidString: idItem) else { return .unknown }
            return .ad(id: id)
        case RoutePath.search.rawValue:
            return getSearchRoute(items: components.queryItems)
        case RoutePath.profile.rawValue:
            guard let idItem = arguments["id"],
                let id = UUID(uuidString: idItem) else { return .unknown }
            return .userProfile(id: id)
        case RoutePath.usp.rawValue, RoutePath.howWorks.rawValue:
            return .usp
        case RoutePath.map.rawValue:
            return .map(latitude: nil, longitude: nil)
        case RoutePath.looks.rawValue:
            return .looks
        default:
            return isWhoppah ? .unknown : .browser(url: url)
        }
        return isWhoppah ? .unknown : .browser(url: url)
    }

    private static func getSearchRoute(items: [URLQueryItem]?) -> Route {
        guard let queryParams = items else { return .search(input: SearchProductsInput()) }
        var attributes = [FilterAttribute]()
        var minPrice: Money?
        var maxPrice: Money?
        var quality: GraphQL.ProductQuality?
        var sort: GraphQL.SearchSort?
        var queryText: String?
        var arReady: Bool?
        var order: GraphQL.Ordering?
        for query in queryParams {
            switch query.name {
            case "artist", "brand", "designer", "color":
                if let value = query.value?.removingPercentEncoding, let type = FilterAttributeType(rawValue: query.name) {
                    // nil title here means we need to look up the title later for display
                    attributes.append(FilterAttribute(type: type, slug: value, title: nil, children: nil))
                }
            case "style", "material", "category":
                if let value = query.value?.removingPercentEncoding, let type = FilterAttributeType(rawValue: query.name) {
                    // slug as title will look up the title via Lokalise
                    attributes.append(FilterAttribute(type: type, slug: value, title: value, children: nil))
                }
            case "min-price":
                if let value = query.value, let price = Money(value) {
                    minPrice = price
                }
            case "max-price":
                if let value = query.value, let price = Money(value) {
                    maxPrice = price
                }
            case "quality":
                if let value = query.value {
                    for qualityCase in GraphQL.ProductQuality.allCases {
                        if value.lowercased() == qualityCase.rawValue.lowercased() {
                            quality = qualityCase
                            break
                        }
                    }
                }
            case "sort":
                if let value = query.value {
                    for sortCase in GraphQL.SearchSort.allCases {
                        if value.lowercased() == sortCase.rawValue.lowercased() {
                            sort = sortCase
                            break
                        }
                    }
                }
            case "order":
                if let value = query.value {
                    for orderCase in GraphQL.Ordering.allCases {
                        if value.lowercased() == orderCase.rawValue.lowercased() {
                            order = orderCase
                            break
                        }
                    }
                }
            case "query":
                if let value = query.value?.removingPercentEncoding {
                    queryText = value.replacingOccurrences(of: "+", with: " ")
                }
            case "ar_ready":
                if let text = query.value, let value = Bool(text) {
                    arReady = value
                }
            default:
                break
            }
        }
        
        var filters = [FilterInput]()
        
        attributes.forEach({ attribute in
            filters.append(attribute.toNewModel)
        })
        
        if let quality = quality {
            filters.append(.init(key: .quality, value: quality.title()))
        }
        if let minPrice = minPrice, let maxPrice = maxPrice {
            filters.append(.init(key: .price, value: "\(minPrice),\(maxPrice)"))
        }
//        if let arReady = arReady {
//            filters.append(.init(key: .ar, value: "\(arReady)".uppercased()))
//        }
        
        return .search(input: .init(
            query: queryText,
            sort: sort?.toWhoppahModel ?? .default,
            order: order?.toWhoppahModel ?? .desc,
            facets: [],
            filters: filters))
    }
}

var navigatorRoute = BehaviorSubject<Navigator.Route>(value: .unknown)
