//
//  SearchFilterPublisher.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 08/04/2022.
//

import Foundation
import Combine

protocol SearchFilterPublisher {
    func registerPublisher(_ publisher: ObservableObjectPublisher?)
}
