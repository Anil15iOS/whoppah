//
//  File.swift
//  
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation

public struct URLAsset {
    public let id: UUID
    public let url: String
    
    public init(id: UUID,
                url: String)
    {
        self.id = id
        self.url = url
    }
}

public extension URLAsset {
    func asURL() -> URL? { URL(string: url) }
}
