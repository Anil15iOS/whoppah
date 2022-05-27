//
//  HTTPServiceInterface.swift
//  Whoppah
//
//  Created by Boris Sagan on 9/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext

public protocol HTTPServiceInterface {
    @discardableResult
    func execute<T: Codable>(request: HTTPRequestable, completion: @escaping (Result<T, Error>) -> Void) -> ProgressCancellable
    
    @discardableResult
    func execute<T: Codable>(request: HTTPRequestable, retryNumber: Int, completion: @escaping (Result<T, Error>) -> Void) -> ProgressCancellable

    @discardableResult
    func upload<T: Codable>(request: HTTPRequestable, retryNumber: Int, completion: @escaping (Result<T, Error>) -> Void) -> ProgressCancellable
}

extension HTTPServiceInterface {
    @discardableResult
    func execute<T: Codable>(request: HTTPRequestable, completion: @escaping (Result<T, Error>) -> Void) -> ProgressCancellable {
        execute(request: request, retryNumber: 0, completion: completion)
    }
}
