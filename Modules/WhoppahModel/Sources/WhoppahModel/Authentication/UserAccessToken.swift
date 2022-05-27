//
//  AccessToken.swift
//  WhoppahModel
//
//  Created by Boris Sagan on 11/4/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum UserAccessTokenType: String, Codable {
    case bearer = "Bearer"
    case token = "Token"
}

public class UserAccessToken: Codable {
    // MARK: - Properties

    public let token: String
    public let userID: UUID
    public let authenticationMethod: AuthenticationMethod
    public var type: UserAccessTokenType?
    public let isMerchant: Bool

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case token = "key"
        case userID = "user_id"
        case authenticationMethod = "authentication_method"
        case isMerchant = "is_merchant"
        case type = "type"
    }

    public init(token: String,
                userID: UUID,
                authenticationMethod: AuthenticationMethod,
                type: UserAccessTokenType,
                isMerchant: Bool) {
        self.token = token
        self.userID = userID
        self.authenticationMethod = authenticationMethod
        self.type = type
        self.isMerchant = isMerchant
    }
}
