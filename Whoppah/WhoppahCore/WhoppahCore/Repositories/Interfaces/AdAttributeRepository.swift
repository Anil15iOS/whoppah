//
//  AdAttributeRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

public enum AttributeType: String {
    case brands = "Brand"
    case artists = "Artist"
    case designers = "Designer"
    case styles = "Style"
    case materials = "Material"
    case colors = "Color"
}

public protocol AdAttributeRepository {
    var type: AttributeType { get }
    func loadAttributes<T>() -> Observable<[T]>
}
