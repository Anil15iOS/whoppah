//
//  HTTPError.swift
//  WhoppahCoreNext
//
//  Created by Boris Sagan on 9/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum HTTPError: Error {
    case other
    case emptydata
    case statusCode(url: URL, code: Int, data: Data?)
    case invalidContentType(type: String, data: Data)
    case missingContentType
    case loggedOut
    case jsonDecodeError(error: Error)
    case connectionError(error: Error)
}
