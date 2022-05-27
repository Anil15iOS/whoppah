//
//  CleanDataModelGenerator.swift
//  ApolloCodegen
//
//  Created by Dennis Ippel on 15/03/2022.
//

import Foundation
import AppKit

class CleanDataModelGenerator {
    private let schemaURL: URL
    private let targetURL: URL
    private var modelFile = SwiftFileCreator()
    
    private enum Prefix: String, CaseIterable {
        case directive
        case interface
        case `enum`
        case `type`
        case input
        case union
        case scalar
        case typeMutation = "type Mutation"
        case typeQuery = "type Query"
        case enumRole = "enum ROLE"
        case enumCacheControlScope = "enum CacheControlScope"
        case comment = "\"\"\""
        case deprecated = "@deprecated"
        case none
        
        var shouldIgnore: Bool {
            switch self {
            case .interface,
                    .enum,
                    .input,
                    .type:
                return false
            default:
                return true
            }
        }
        
        var isOneLiner: Bool { [.directive, .union].contains(self) }
        var startDelimiter: String { "{" }
        var endDelimiter: String { "}" }
        
        func toSwiftDeclaration(fromValue value: String, protocolConformances: [String]? = nil) -> String {
            var declaration = ""
            switch self {
            case .interface:
                declaration = value.replacingOccurrences(of: "interface", with: "public protocol")
            case .enum:
                declaration = value.replacingOccurrences(of: "enum", with: "public enum")
            case .input:
                declaration = value.replacingOccurrences(of: "input", with: "public struct", options: .anchored, range: nil)
            case .type:
                declaration = value.replacingOccurrences(of: "type ", with: "public struct ")
                    .replacingOccurrences(of: " implements ", with: ": ")
            default:
                return ""
            }
            
            var isFirstConformance = !declaration.contains(": ")
            
            if let count = protocolConformances?.count, count > 0 {
                declaration = declaration.replacingOccurrences(of: " {", with: "")
            }
            
            protocolConformances?.forEach({ conformance in
                if isFirstConformance {
                    declaration += ": \(conformance)"
                    isFirstConformance = false
                } else {
                    declaration += " & \(conformance)"
                }
            })
            
            if let count = protocolConformances?.count, count > 0 {
                declaration += " {"
            }
            
            return declaration
        }
    }
    
    private var scalars = [String]()
    private var unions = [String: [String]]()
    private var enums = [String]()
    
    private let removeUnions: Bool
    private let replaceFloatsWithDoubles: Bool
    
    private struct TypeToReplace {
        let enclosingType: String
        let typeName: String
    }
    
    private struct LetToVar {
        let enclosingType: String
        let paramName: String
    }
    
    private struct ParamToOmit {
        let enclosingType: String
        let paramName: String
    }
    
    private struct ParamToAdd {
        let enclosingType: String
        let paramName: String
        let comment: String?
    }
    
    private struct ProtocolConformationToAdd {
        let enclosingType: String
        let protocolNames: [String]
    }
    
    /*
     To prevent these messages:
     - Value type 'xx' cannot have a stored property that recursively contains it
     - Value type 'xx' has infinite size
     */
    private let typesToReplaceWithUUIDs: [TypeToReplace] = [
        .init(enclosingType: "Product", typeName: "Order"),
        .init(enclosingType: "Order", typeName: "Shipment"),
        .init(enclosingType: "Order", typeName: "Review"),
        .init(enclosingType: "Auction", typeName: "Bid"),
        .init(enclosingType: "Auction", typeName: "Product"),
        .init(enclosingType: "Bid", typeName: "Auction"),
        .init(enclosingType: "Bid", typeName: "Merchant"),
        .init(enclosingType: "Bid", typeName: "Order"),
        .init(enclosingType: "Bid", typeName: "Thread"),
        .init(enclosingType: "Category", typeName: "Category"),
        .init(enclosingType: "Page", typeName: "Page"),
        .init(enclosingType: "MediaCreateInput", typeName: "Upload"),
        .init(enclosingType: "SearchFacetValue", typeName: "Category"),
        .init(enclosingType: "SearchFacetValue", typeName: "Merchant")
    ]
    
    private let paramsToOmit: [ParamToOmit] = [
        .init(enclosingType: "Message", paramName: "metadata"),
        .init(enclosingType: "Merchant", paramName: "stripeAccount"),
        .init(enclosingType: "Merchant", paramName: "pending_requirements"),
        .init(enclosingType: "Merchant", paramName: "pending_balance"),
        .init(enclosingType: "Merchant", paramName: "pending_payouts"),
        .init(enclosingType: "Merchant", paramName: "completed_payouts")
    ]
    
    private let paramsToAdd: [ParamToAdd] = [
        .init(enclosingType: "AddressInput",
              paramName: "public var id: UUID?",
              comment: nil),
        .init(enclosingType: "MemberInput",
              paramName: "public var id: UUID?",
              comment: nil),
        .init(enclosingType: "MerchantInput",
              paramName: "public var id: UUID?",
              comment: nil),
        .init(enclosingType: "Merchant",
              paramName: "@IgnoreEquatable public var rawObject: AnyObject?",
              comment: "// Temporary while switching between new and old architures. Will hold GraphQL object."),
        .init(enclosingType: "Member",
              paramName: "@IgnoreEquatable public var rawObject: AnyObject?",
              comment: "// Temporary while switching between new and old architures. Will hold GraphQL object."),
        .init(enclosingType: "Product",
              paramName: "public let fullImages: [Image]",
              comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let thumbnails: [Image]",
              comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let brands: [Brand]", comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let colors: [Color]", comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let labels: [Label]", comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let styles: [Style]", comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let artists: [Artist]", comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let designers: [Designer]", comment: nil),
        .init(enclosingType: "Product",
              paramName: "public let materials: [Material]", comment: nil)
    ]
    
    private let protocolConformationsToAdd: [ProtocolConformationToAdd] = [
        .init(enclosingType: "Product", protocolNames: ["ProductTileItemRepresentable"]),
        .init(enclosingType: "Designer", protocolNames: ["Hashable", "AbstractAttribute"]),
        .init(enclosingType: "AdditionalInfo", protocolNames: ["Hashable"]),
        .init(enclosingType: "Artist", protocolNames: ["Hashable"]),
        .init(enclosingType: "Brand", protocolNames: ["Hashable"]),
        .init(enclosingType: "Color", protocolNames: ["Hashable"]),
        .init(enclosingType: "Favorite", protocolNames: ["Hashable"]),
        .init(enclosingType: "FavoriteCollection", protocolNames: ["Hashable"]),
        .init(enclosingType: "Label", protocolNames: ["Hashable"]),
        .init(enclosingType: "Material", protocolNames: ["Hashable"]),
        .init(enclosingType: "Style", protocolNames: ["Hashable"]),
        .init(enclosingType: "Subject", protocolNames: ["Hashable"]),
        .init(enclosingType: "UsageSign", protocolNames: ["Hashable"]),
        .init(enclosingType: "SearchFacet", protocolNames: ["Hashable"]),
        .init(enclosingType: "SearchFacetValue", protocolNames: ["Hashable"])
    ]
    
    private let changeAccessorLetToVar: [LetToVar] = [
        .init(enclosingType: "Product", paramName: "favorite")
    ]
    
    init(schemaURL: URL,
         targetURL: URL,
         removeUnions: Bool = true,
         replaceFloatsWithDoubles: Bool = true) {
        self.schemaURL = schemaURL
        self.removeUnions = removeUnions
        self.targetURL = targetURL
        self.replaceFloatsWithDoubles = replaceFloatsWithDoubles
        
        do {
            try FileManager.default.createDirectory(at: self.targetURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            log("Created target dir \(self.targetURL)")
        } catch {
            log("Couldn't create target dir \(self.targetURL): \(error)", isWarning: true)
        }
    }
    
    func generate() throws {
        let data = try String(contentsOfFile: schemaURL.path, encoding: .utf8)
        let lines = data.components(separatedBy: .newlines)
        log("Start pre-processing \(lines.count) lines.")
        preprocess(lines: lines)
    }
    
    private func preprocess(lines: [String]) {
        var processed = [String]()
        var isComment = false
        
        for i in 0..<lines.count {
            var line = lines[i]
            let isDeprecated = line.contains(Prefix.deprecated.rawValue)
            
            guard !line.contains("\"\"\"\"\"\""),
                  !line.isEmpty,
                  !(isComment && !line.starts(with: Prefix.comment.rawValue)),
                  isDeprecated != true
            else { continue }
            
            if replaceFloatsWithDoubles {
                line = line.replacingOccurrences(of: ": Float", with: ": Double")
            }
            
            if line.starts(with: Prefix.scalar.rawValue),
               let scalarName = line.components(separatedBy: " ").last
            {
                scalars.append(scalarName)
                continue
            } else if line.starts(with: Prefix.enum.rawValue),
                      let enumName = line
                .replacingOccurrences(of: "\(Prefix.enum.rawValue) ", with: "")
                .components(separatedBy: " ").first
            {
                enums.append(enumName)
            } else if line.starts(with: Prefix.comment.rawValue) {
                print("comment \(line)")
                guard !(line.count > Prefix.comment.rawValue.count * 2 && line.hasSuffix(Prefix.comment.rawValue)) else {
                    // single line comment
                    continue
                }
                isComment.toggle()
                continue
            } else if line.starts(with: Prefix.union.rawValue) {
                let components = line
                    .replacingOccurrences(of: "\(Prefix.union.rawValue) ", with: "")
                    .components(separatedBy: " = ")
                
                guard let unionName = components.first,
                      let unionTypes = components.last?.components(separatedBy: " | ")
                else { continue }

                unions[unionName] = unionTypes
            }
            
            processed.append(line)
        }
        
        log("Start parsing \(processed.count) lines.")
        var readingBlock: Prefix = .none
        var currentType: String = ""
        readNextChunk(lines: &processed,
                      readingBlock: &readingBlock,
                      currentType: &currentType)
    }
    
    private func readNextChunk(lines: inout [String],
                               readingBlock: inout Prefix,
                               currentType: inout String)
    {
        if lines.isEmpty {
            finish()
            return
        }
        
        let firstLine = lines.removeFirst()
        
        defer {
            readNextChunk(lines: &lines,
                          readingBlock: &readingBlock,
                          currentType: &currentType)
        }
        
        if readingBlock != .none {
            if firstLine.starts(with: readingBlock.endDelimiter) {
                if !readingBlock.shouldIgnore {
                    addCustomParamsIfApplicable(enclosingType: currentType)
                    if readingBlock == .type || readingBlock == .input {
                        modelFile.addInitializer()
                    } else if readingBlock == .enum {
                        modelFile.append("\tcase unknown")
                    }
                    
                    modelFile.append("}")
                    writeFile(forType: currentType)
                }
                
                currentType = ""
                readingBlock = .none
            } else if !readingBlock.shouldIgnore {
                if readingBlock == .enum {
                    modelFile.append(parseEnumCase(firstLine))
                } else {
                    if let param = parseParameter(firstLine,
                                                  prefix: readingBlock,
                                                  enclosingType: currentType)
                    {
                        modelFile.append(param)
                    }
                }
            }
            return
        }
        
        var foundPrefix: Prefix?
        
        Prefix.allCases.forEach { prefixCase in
            if firstLine.starts(with: prefixCase.rawValue) {
                foundPrefix = prefixCase
            }
        }
        
        guard let foundPrefix = foundPrefix else {
            log("Unrecognized prefix in line '\(firstLine)'", isWarning: true)
            return
        }
        
        guard let typeName = firstLine
            .replacingOccurrences(of: "\(foundPrefix.rawValue) ", with: "")
            .components(separatedBy: " ").first
        else {
            log("Couldn't get type name: \(firstLine)", isWarning: true)
            return
        }
                
        currentType = typeName
        log("Found prefix \(foundPrefix.rawValue) typed \(currentType)")
        
        if foundPrefix.shouldIgnore {
            log("⚡️ Ignoring prefix")
            if foundPrefix.isOneLiner { return }
            else {
                readingBlock = foundPrefix
                return
            }
        } else {
            log("🔍 Reading prefix")
            modelFile.create(forTypeName: typeName)
            readingBlock = foundPrefix
            
            var conformances: [String] = protocolConformationsToAdd.first { $0.enclosingType == typeName }?.protocolNames ?? [String]()
            
            if foundPrefix == .enum {
                conformances = ["String, CaseIterable"]
            } else if foundPrefix == .type {
                conformances = ["Equatable"] + conformances
            }

            modelFile.append(foundPrefix.toSwiftDeclaration(fromValue: firstLine,
                                                            protocolConformances: conformances))
        }
    }
    
    private func parseEnumCase(_ line: String) -> String {
        var l = line
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\t", with: "")
        l = l.snakeCaseToCamelCase
        
        if ["default"].contains(l) {
            l = "`\(l)`"
        }
        
        return "\tcase \(l)"
    }
    
    private func parseParameter(_ line: String, prefix: Prefix, enclosingType: String) -> String? {
        var l = line
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\t", with: "")
        
        let regex = try! NSRegularExpression(pattern: "\\(.*\\)",
                                             options: NSRegularExpression.Options.caseInsensitive)
        
        l = regex.stringByReplacingMatches(in: l,
                                           options: [],
                                           range: NSMakeRange(0, l.count),
                                           withTemplate: "")
        
        let split = l.components(separatedBy: ":")
        
        guard var paramName = split.first,
              var paramType = split.last
        else {
            log("⚠️ Error parsing param \(line)")
            return nil
        }
        
        let isNullable = !paramType.contains("!")
        let hasDefaultValue = paramType.contains("=")
        paramType = replaceTypeIfApplicable(paramType.replacingOccurrences(of: "!", with: ""))
        paramType = replaceTypeIfApplicable(paramType, enclosingType: enclosingType)
        
        guard !shouldSkipParameter(ofType: paramType),
              !shouldSkipParameter(named: paramName, enclosingType: enclosingType)
        else {
            return nil
        }
        
        paramType = isNullable && !hasDefaultValue ? "\(paramType)?" : "\(paramType)"
        paramName = paramName.snakeCaseToCamelCase
        
        if hasDefaultValue {
            if let enumName = paramType.components(separatedBy: "=").first,
               let value = paramType.components(separatedBy: "=").last,
               enums.contains(enumName)
            {
                paramType = "\(enumName) = .\(value.snakeCaseToCamelCase)"
            } else {
                paramType = paramType.replacingOccurrences(of: "=", with: " = ")
            }
        }
        
        if prefix == .interface {
            return "\tvar \(paramName): \(paramType) { get }"
        } else {
            var line = "\tpublic \(hasDefaultValue ? "var" : "let") \(paramName): \(paramType)"
            
            if let replaced = replaceAccessorIfApplicable(line, enclosingType: enclosingType) {
                line = replaced
            }
            
            return line
        }
    }
    
    private func shouldSkipParameter(named paramName: String, enclosingType: String) -> Bool {
        return paramsToOmit.contains(where: { paramToOmit in
            return paramToOmit.paramName == paramName && paramToOmit.enclosingType == enclosingType
        })
    }
    
    private func shouldSkipParameter(ofType paramType: String) -> Bool {
        let param = paramType.removingBrackets
        
        if removeUnions && unions[param] != nil {
            log("🧅 Omitting union parameter \(paramType)")
            return true
        }
        
        return false
    }
    
    private func addCustomParamsIfApplicable(enclosingType: String) {
        paramsToAdd.forEach { paramToAdd in
            if paramToAdd.enclosingType == enclosingType {
                if let comment = paramToAdd.comment {
                    modelFile.append("\t\(comment)")
                } else {
                    modelFile.append("\t// Custom parameter")
                }
                modelFile.append("\t\(paramToAdd.paramName)")
            }
        }
    }
    
    private func replaceTypeIfApplicable(_ paramType: String) -> String {
        switch paramType.replacingOccurrences(of: "?", with: "") {
        case "DateTime": return "Date"
        case "Boolean": return "Bool"
        case let str where str.starts(with: "Boolean"): return str.replacingOccurrences(of: "Boolean", with: "Bool")
        case "Location": return "CLLocationCoordinate2D"
        default: return paramType
        }
    }
    
    private func replaceTypeIfApplicable(_ paramType: String, enclosingType: String) -> String {
        let isArray = paramType.isArrayString
        let cleanParamType = paramType.removingBrackets
        
        if typesToReplaceWithUUIDs.contains(where: { typeToReplace in
            typeToReplace.typeName == cleanParamType && typeToReplace.enclosingType == enclosingType && !isArray
        }) {
            log("Replacing \(enclosingType).\(paramType) with UUID")
            return "UUID"
        }
        
        return paramType
    }
    
    private func replaceAccessorIfApplicable(_ line: String, enclosingType: String) -> String? {
        guard line.components(separatedBy: " ").count > 3
        else { return nil }
        
        var paramName = line.components(separatedBy: " ")[2]
        paramName.removeLast()
        
        if changeAccessorLetToVar.contains(where: { paramToUpdate in
            paramToUpdate.paramName == paramName && paramToUpdate.enclosingType == enclosingType
        }) {
            log("Replacing \(enclosingType).\(paramName) accessor from let to var")
            return line.replacingOccurrences(of: "let ", with: "var ")
        }
            
        return nil
    }
    
    private func writeFile(forType typeName: String) {
        do {
            try modelFile.write(toBaseURL: targetURL)
        } catch {
            log("Could not write file", isWarning: true)
        }
        modelFile.reset()
    }
    
    private func finish() {
        log("Finished parsing.")
    }
    
    private func log(_ message: String, isWarning: Bool = false) {
        if isWarning {
            print("⚠️ \(message)")
        } else {
            print("🧼 \(message)")
        }
    }
}
