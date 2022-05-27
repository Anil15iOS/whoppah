//
//  String+Extensions.swift
//  
//
//  Created by Dennis Ippel on 15/03/2022.
//

import Foundation

extension String {
    var snakeCaseToCamelCase: String {
        let buf: NSString = capitalized.replacingOccurrences(
            of: "(\\w{0,1})_",
            with: "$1",
            options: .regularExpression,
            range: nil) as NSString
        return buf.replacingCharacters(
            in: NSMakeRange(0, 1),
            with: buf.substring(to: 1).lowercased()) as String
    }
    
    var removingBrackets: String {
        return self
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
    
    var isArrayString: Bool {
        guard self.count > 1 else { return false }
        return self.prefix(1) == "[" && self.suffix(1) == "]"
    }
}
