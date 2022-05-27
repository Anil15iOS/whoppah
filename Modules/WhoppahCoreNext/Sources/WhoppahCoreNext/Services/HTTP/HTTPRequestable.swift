//
//  HTTPRequestable.swift
//  WhoppahCoreNext
//
//  Created by Boris Sagan on 9/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol HTTPRequestable {
    var baseURL: String? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [String: Any]? { get }
    var body: [String: Any]? { get }
    var formData: [String: Any]? { get }
    var headers: [String: Any]? { get }
    /// Total number of retries possible for this request
    var maxRetries: Int? { get }
    /// Response parser (for custom responses that don't conform to our expected structure)
    var parser: HttpResponseParser? { get }
}

extension HTTPRequestable {
    public var maxRetries: Int? { 0 }
    public var baseURL: String? { nil }
    public var parser: HttpResponseParser? { nil }
    public var query: [String: Any]? { nil }
    public var body: [String: Any]? { nil }
    public var formData: [String: Any]? { nil }
    public var headers: [String: Any]? { nil }
}
