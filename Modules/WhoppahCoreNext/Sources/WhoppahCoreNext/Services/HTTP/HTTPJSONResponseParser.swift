//
//  HTTPJSONResponseParser.swift
//  WhoppahCoreNext
//
//  Created by Eddie Long on 26/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class HTTPJSONResponseParser: HttpResponseParser {
    public init() {}

    public func parse<T>(data: Data, headers: [AnyHashable: Any]) -> Result<T, Error> where T: Decodable {
        if let contentType = find(header: "content-type", inHeaders: headers)?.lowercased() {
            if !contentType.contains("application/json") {
                return .failure(HTTPError.invalidContentType(type: contentType, data: data))
            }
        } else {
            return .failure(HTTPError.missingContentType)
        }

        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(T.self, from: data)
            return .success(response)
        } catch {
            return .failure(HTTPError.jsonDecodeError(error: error))
        }
    }
    
    private func find(header: String, inHeaders headers: [AnyHashable: Any]) -> String? {
        let keyValues = headers.map { (String(describing: $0.key).lowercased(), String(describing: $0.value)) }
        return keyValues.first(where: { $0.0 == header.lowercased() })?.1
    }
}
