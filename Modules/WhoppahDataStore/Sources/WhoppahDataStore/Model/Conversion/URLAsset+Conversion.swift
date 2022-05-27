//
//  File.swift
//  
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation
import WhoppahModel

extension GraphQL.GetMeQuery.Data.Me.Merchant.Avatar: WhoppahModelConvertable {
    var toWhoppahModel: URLAsset {
        .init(id: self.id,
              url: self.url)
    }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant.Cover: WhoppahModelConvertable {
    var toWhoppahModel: URLAsset {
        .init(id: self.id,
              url: self.url)
    }
}
