//
//  ChildrenContainable.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 11/04/2022.
//

public protocol ChildrenContainable {
    associatedtype ChildType
    
    var children: [ChildType]? { get }
}
