//
//  HTTPUploadRequestable.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 16/12/2021.
//

import Foundation

public protocol HTTPUploadRequestable: HTTPRequestable {
    var file: [String: Data]? { get }
    var filename: String? { get }
    var mimeType: String? { get }
}
