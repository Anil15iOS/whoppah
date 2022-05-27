//
//  Product+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 05/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension WhoppahCore.Product {
    var supportsAR: Bool {
        guard Device.supportsAR() else { return false }
        guard getARType(ar, size: [width, height]) != nil else { return false }
        return true
    }
}

func canDeleteProduct(_ productState: GraphQL.ProductState, _ auctionState: GraphQL.AuctionState?) -> Bool {
    var canDelete = true
    switch productState {
    case .accepted:
        if let auction = auctionState {
            switch auction {
            case .reserved, .completed, .banned:
                canDelete = false
            case .__unknown:
                canDelete = false
            default: break
            }
        }
    case .rejected, .curation, .draft, .updated, .archive:
        break
    case .banned, .canceled:
        canDelete = false
    case .__unknown:
        canDelete = false
    }
    return canDelete
}

func canEditProduct(_ productState: GraphQL.ProductState, _ auctionState: GraphQL.AuctionState?) -> Bool {
    var canEdit = true
    switch productState {
    case .accepted:
        if let auction = auctionState {
            switch auction {
            case .reserved, .completed, .banned:
                canEdit = false
            case .__unknown:
                canEdit = false
            default: break
            }
        }
    case .rejected, .curation, .draft, .updated, .archive: break
    case .banned, .canceled: canEdit = false
    case .__unknown:
        canEdit = false
    }
    return canEdit
}

func canRepostProduct(_ productState: GraphQL.ProductState, _ auctionState: GraphQL.AuctionState?) -> Bool {
    var canRepost = false
    switch productState {
    case .accepted:
        if let auction = auctionState {
            switch auction {
            case .expired:
                canRepost = true
            case .__unknown:
                break
            default:
                break
            }
        }
    case .rejected, .banned, .curation, .draft, .canceled, .updated, .archive:
        break

    case .__unknown:
        break
    }
    return canRepost
}
