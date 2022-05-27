//
//  HTTPResponseParser.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 16/12/2021.
//

import Foundation

public protocol HttpResponseParser {
    func parse<T>(data: Data, headers: [AnyHashable: Any]) -> Result<T, Error> where T: Decodable
}
