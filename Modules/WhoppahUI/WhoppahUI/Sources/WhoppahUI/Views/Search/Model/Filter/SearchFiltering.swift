//
//  SearchFiltering.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import Combine
import WhoppahModel

protocol SearchFiltering: SearchFilterResettable & SearchFilterValueInspectable {
    var filterId: String { get }
    var searchFilterKey: SearchFilterKey? { get }
    var filterType: SearchFilterType { get }
    func registerPublisher(_ publisher: ObservableObjectPublisher?)
}
