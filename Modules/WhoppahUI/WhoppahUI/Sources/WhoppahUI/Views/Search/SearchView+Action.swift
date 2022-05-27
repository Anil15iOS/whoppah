//  
//  SearchView+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/03/2022.
//

import Foundation
import WhoppahModel

public extension SearchView {
    enum TrackingAction {
        case didSelectProduct(id: ProductTileItem)
        case didScrollSearch(page: Int)
        case didTapShowFilters
        case didTapSort(type: WhoppahModel.SearchSort, order: WhoppahModel.Ordering)
        case didPerformSearch(query: String)
    }        

    enum OutboundAction {
        case didReportError(error: Error)
        case didTapCloseButton
        case didSelectProduct(id: UUID)
        case showLoginModal(title: String, description: String)
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
        case searchAction(input: SearchProductsInput, clearCurrentResults: Bool)
        case didReceiveSearchResults(Result<ProductSearchResultsSet, Error>)
        case fetchNextAttribute
        case didFinishFetchingAttributes(Result<[AbstractAttribute], Error>)
        case fetchCategoryHierarchy
        case didFinishFetchingCategoryHierarchy(Result<[WhoppahModel.Category], Error>)
        case fetchCategories(bySlug: String?)
        case didFinishFetchingCategories(Result<[WhoppahModel.Category], Error>)
        case createFavorite(productId: UUID)
        case didFinishCreatingFavorite(Result<FavoritedProduct, Error>)
        case removeFavorite(productId: UUID, favorite: Favorite)
        case didFinishRemovingFavorite(Result<FavoritedProduct, Error>)
        case didTapSaveSearch(input: SearchProductsInput)
        case didFinishSavingSearch(Result<Bool, Error>)
        case didTapShowResultsButton
        case didTapCloseFiltersButton
        case didTapShowFiltersButton
        case fetchUserFavorites
        case didFinishFetchingUserFavorites(Result<[UUID: Favorite], Error>)
    }
}

extension SearchView.TrackingAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (let .didSelectProduct(lId), let .didSelectProduct(rId)):
            return lId == rId
        case (let .didScrollSearch(lPage), let .didScrollSearch(rPage)):
            return lPage == rPage
        case (.didTapShowFilters, .didTapShowFilters):
            return true
        case (let .didTapSort(lType, lOrder), let .didTapSort(rType, rOrder)):
            return lType == rType && lOrder == rOrder
        case (let .didPerformSearch(lQuery), let .didPerformSearch(rQuery)):
            return lQuery == rQuery
        default:
            return false
        }
    }
}

extension SearchView.OutboundAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.didTapCloseButton, .didTapCloseButton):
            return true
        case (let .didSelectProduct(lId), let .didSelectProduct(rId)):
            return lId == rId
        default:
            return false
        }
    }
}

extension SearchView.Action: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.loadContent, .loadContent),
            (.fetchNextAttribute, .fetchNextAttribute),
            (.didTapShowResultsButton, .didTapShowResultsButton),
            (.didTapCloseFiltersButton, .didTapCloseFiltersButton),
            (.didTapShowFiltersButton, .didTapShowFiltersButton),
            (.fetchUserFavorites, .fetchUserFavorites),
            (.fetchCategoryHierarchy, .fetchCategoryHierarchy):
            return true
        case (let .didFinishLoadingContent(lResult), let .didFinishLoadingContent(rResult)):
            return compare(lResult, rResult)
        case (let .trackingAction(lAction), let .trackingAction(rAction)):
            return lAction == rAction
        case (let .outboundAction(lAction), let .outboundAction(rAction)):
            return lAction == rAction
        case (let .searchAction(lInput, lClear), let .searchAction(rInput, rClear)):
            return lInput == rInput && lClear == rClear
        case (let .didReceiveSearchResults(lResult), let .didReceiveSearchResults(rResult)):
            return compare(lResult, rResult)
        case (let .didFinishFetchingAttributes(lResult), let .didFinishFetchingAttributes(rResult)):
            if case let .success(lValue) = lResult,
               case let .success(rValue) = rResult {
                guard lValue.count == rValue.count else { return false }
                
                for i in 0..<lValue.count {
                    let l = lValue[i]
                    let r = rValue[i]
                    
                    if l.slug == r.slug &&
                        l.id == r.id &&
                        l.description == r.description &&
                        l.title == r.title {
                        continue
                    } else {
                        return false
                    }
                }
                
                return true
            } else if case let .failure(lError) = lResult,
                      case let .failure(rError) = rResult,
                      compare(lError, rError) {
                return true
            } else {
                return false
            }
        case (let .fetchCategories(lSlug), let .fetchCategories(rSlug)):
            return lSlug == rSlug
        case (let .didFinishFetchingCategories(lResult), let .didFinishFetchingCategories(rResult)):
            return compare(lResult, rResult)
        case (let .createFavorite(lProduct), let .createFavorite(rProduct)):
            return lProduct == rProduct
        case (let .didFinishCreatingFavorite(lResult), let .didFinishCreatingFavorite(rResult)):
            return compare(lResult, rResult)
        case (let .removeFavorite(lProduct, lFavorite), let .removeFavorite(rProduct, rFavorite)):
            return lProduct == rProduct && lFavorite == rFavorite
        case (let .didFinishRemovingFavorite(lResult), let .didFinishRemovingFavorite(rResult)):
            return compare(lResult, rResult)
        case (let .didTapSaveSearch(lInput), let .didTapSaveSearch(rInput)):
            return lInput == rInput
        case (let .didFinishSavingSearch(lResult), let .didFinishSavingSearch(rResult)):
            return compare(lResult, rResult)
        case (let .didFinishFetchingUserFavorites(lResult), let .didFinishFetchingUserFavorites(rResult)):
            return compare(lResult, rResult)
        default:
            return false
        }
    }
}
