//
//  ResultCompare.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 02/02/2022.
//

import Foundation

func compare<T: Equatable, U: Error>(_ lResult: Result<T, U>, _ rResult: Result<T, U>) -> Bool {
    if case let .success(lValue) = lResult,
       case let .success(rValue) = rResult,
       lValue == rValue {
        return true
    } else if case let .failure(lError) = lResult,
              case let .failure(rError) = rResult,
              compare(lError, rError) {
        return true
    } else {
        return false
    }
}

func compare(_ lhs: Error, _ rhs: Error) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    let error1 = lhs as NSError
    let error2 = rhs as NSError
    return error1.domain == error2.domain && error1.code == error2.code && "\(lhs)" == "\(rhs)"
}
