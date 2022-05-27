//
//  WhoppahError.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 01/12/2021.
//

import Foundation

public enum WhoppahError: Error {
    case deallocatedSelf
    case notImplemented
    case userNotSignedIn
    case missingChatThreadId
    case noTranslationAvailable
    case couldNotCreateAbuseReport
    case missingMerchantId
    case couldNotFetchProductMissingIdentifierOrSlug
}
