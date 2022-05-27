//
//  CurrentValueObject+Extensions.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 06/01/2022.
//

import Foundation
import Combine

public extension Publisher {
    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }
    
    func sink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }
}
