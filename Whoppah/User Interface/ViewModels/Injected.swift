//
//  Injected.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import Resolver

@propertyWrapper
struct Injected<Service> {
    var service: Service?
    var container: Resolver?
    var name: String?
    public var wrappedValue: Service {
        mutating get {
            if service == nil {
                service = (container ?? Resolver.root).resolve(
                    Service.self,
                    name: Resolver.Name(name ?? ""),
                    args: nil
                )
            }
            return service!
        }
        mutating set {
            service = newValue
        }
    }

    public var projectedValue: Injected<Service> {
        get {
            self
        }
        mutating set {
            self = newValue
        }
    }
}
