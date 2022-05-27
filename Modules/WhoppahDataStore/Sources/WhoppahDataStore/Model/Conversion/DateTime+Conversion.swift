//
//  DateTime+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 16/03/2022.
//

import Foundation

extension DateTime : WhoppahModelConvertable {
    var toWhoppahModel: Date {
        self.date
    }
}
