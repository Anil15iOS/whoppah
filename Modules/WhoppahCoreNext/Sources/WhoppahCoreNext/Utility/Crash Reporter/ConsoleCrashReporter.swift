//
//  ConsoleCrashReporter.swift
//  
//
//  Created by Dennis Ippel on 01/12/2021.
//

import Foundation

public struct ConsoleCrashReporter: CrashReporter {
    public var userId: String?
    public var enabled: Bool = true
    
    public init() {}
    
    public func log(event: String, withInfo info: [String : Any]?) {
        guard enabled else { return }
        
        print("🗓 [EVENT] \(event) [INFO] \(info?.description ?? "None")")
    }
    
    public func log(error: Error,
                    withInfo info: [String : Any]?,
                    file: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        guard enabled else { return }
        
        print("🧨 [ERROR] \(error.localizedDescription) from \(file):\(line):\(function)")
    }
}
