//
//  AuthenticationMethod.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 13/01/2022.
//

import Foundation

public enum AuthenticationMethod: String, Codable {
    case email
    case google
    case facebook
    case apple
}
