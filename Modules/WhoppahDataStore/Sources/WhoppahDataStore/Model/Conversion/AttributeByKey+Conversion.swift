//
//  AttributeByKey+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 23/03/2022.
//

import Foundation
import WhoppahModel

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsMaterial: WhoppahModelConvertable {
    var toWhoppahModel: Material {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug)
    }
}

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsBrand: WhoppahModelConvertable {
    var toWhoppahModel: Brand {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              countryOfOrigin: nil)
    }
}

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsArtist: WhoppahModelConvertable {
    var toWhoppahModel: Artist {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              countryOfOrigin: nil)
    }
}

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsColor: WhoppahModelConvertable {
    var toWhoppahModel: Color {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              hex: self.hex)
    }
}

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsLabel: WhoppahModelConvertable {
    var toWhoppahModel: Label {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug,
              hex: nil)
    }
}

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsStyle: WhoppahModelConvertable {
    var toWhoppahModel: Style {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug)
    }
}

extension GraphQL.GetAttributeQuery.Data.AttributeByKey.AsDesigner: WhoppahModelConvertable {
    var toWhoppahModel: Designer {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              countryOfOrigin: nil)
    }
}
