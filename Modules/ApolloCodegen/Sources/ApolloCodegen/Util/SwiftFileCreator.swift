//
//  SwiftFileCreator.swift
//  ApolloCodeGen
//
//  Created by Dennis Ippel on 16/03/2022.
//

import Foundation

class SwiftFileCreator {
    private var contents = ""
    private var typeName = ""
    
    private struct PropTypeVal {
        let propertyName: String
        let propertyType: String
    }
    
    func create(forTypeName typeName: String) {
        self.typeName = typeName
        addCommentAndImports(typeName: typeName)
    }
    
    func append(_ line: String) {
        contents += "\(line)\n"
    }
    
    func reset() {
        contents = ""
        typeName = ""
    }
    
    func addInitializer() {
        let publicLet = "public let "
        let publicVar = "public var "
        
        let lines = "\(contents)".split(whereSeparator: \.isNewline)
        var properties = [PropTypeVal]()
        lines.forEach { line in
            var l = line.replacingOccurrences(of: "\t", with: "")
            l = l.replacingOccurrences(of: "@IgnoreEquatable ", with: "")
            
            if l.starts(with: publicLet) || l.starts(with: publicVar) {
                l = l.replacingOccurrences(of: publicLet, with: "")
                l = l.replacingOccurrences(of: publicVar, with: "")
                
                if let propertyName = l.components(separatedBy: ": ").first,
                   let propertyType = l.components(separatedBy: ": ").last
                {
                    properties.append(.init(propertyName: propertyName,
                                            propertyType: propertyType))
                }
            }
        }
        
        append("\n\tpublic init(")
        
        for i in 0..<properties.count {
            let property = properties[i]
            var value = property.propertyType.suffix(1) == "?" ? "\(property.propertyType) = nil" : property.propertyType
            
            value = value.replacingOccurrences(of: "\n", with: "")
            let lastChar = i < properties.count - 1 ? "," : ""
            append("\t\t\(property.propertyName): \(value)\(lastChar)")
        }
        
        append("\t) {")
        
        for i in 0..<properties.count {
            let property = properties[i]
            append("\t\tself.\(property.propertyName) = \(property.propertyName)")
        }
        
        append("\t}")
    }
    
    func write(toBaseURL baseURL: URL) throws {
        let url = baseURL.appendingPathComponent("\(typeName).swift", isDirectory: false)
        try contents.write(to: url,
                           atomically: true,
                           encoding: .utf8)
    }
    
    private func addCommentAndImports(typeName: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        append("//")
        append("//  \(typeName).swift")
        append("//  WhoppahModel")
        append("//")
        append("//  Created by CleanDataModelGenerator.")
        append("//")
        
        append("import Foundation")
        append("import CoreLocation")
        append("")
    }
}
