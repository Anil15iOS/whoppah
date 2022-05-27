//
//  Lang+Conversion.swift
//  
//
//  Created by Marko Stojkovic on 21.4.22..
//

import Foundation
import WhoppahModel

extension GraphQL.Lang: WhoppahModelConvertable {
    var toWhoppahModel: Lang {
        switch self {
        case .nl:           return .nl
        case .en:           return .en
        case .fr:           return .fr
        case .de:           return .de
        case .es:           return .es
        case .__unknown:    return .unknown
        }
    }
}

extension WhoppahModel.Lang {
  var toGraphQLLang: GraphQL.Lang {
    switch self {
    case .nl:        return .nl
    case .en:        return .en
    case .fr:        return .fr
    case .de:        return .de
    case .es:        return .es
    case .unknown:   return .__unknown("")
    }
  }
}
