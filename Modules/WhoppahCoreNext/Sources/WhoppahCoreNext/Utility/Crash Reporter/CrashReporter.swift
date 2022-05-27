//
//  File.swift
//  
//
//  Created by Dennis Ippel on 01/12/2021.
//

import Foundation

public protocol CrashReporter {
    var userId: String? { get set }
    var enabled: Bool { get set }
    
    func log(event: String,
             withInfo info: [String: Any]?)
    func log(error: Error,
             withInfo info: [String: Any]?,
             file: String,
             line: Int,
             function: String)
}

public extension CrashReporter {
    func log(error: Error,
             withInfo info: [String : Any]? = nil,
             file: String = #file,
             line: Int = #line,
             function: String = #function) {
        log(error: error,
            withInfo: info,
            file: file,
            line: line,
            function: function)
    }
}
