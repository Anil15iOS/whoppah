//
//  Category+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 02/12/2021.
//

import WhoppahModel
import Foundation

extension GraphQL.ProductQuery.Data.Product.Category: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        
        return .init(id: self.id,
                     title: self.title,
                     slug: self.slug,
                     images: [],
                     videos: [])
    }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        let categories = self.items.map { $0.toWhoppahModel }
        
        var image: WhoppahModel.Image? = nil
        
        if let asImage = self.media.compactMap({ $0.asImage }).first {
            image = .init(id: asImage.id,
                          url: asImage.url,
                          type: .default,
                          position: 0)
        }
        
        return .init(id: self.id,
                     children: categories,
                     title: "",
                     description: self.description,
                     slug: self.slug,
                     link: self.link,
                     level: 0,
                     image: image,
                     images: [],
                     videos: [])
    }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        let categories = self.items.map { $0.toWhoppahModel }
        
        var image: WhoppahModel.Image? = nil
        
        if let asImage = self.media.compactMap({ $0.asImage }).first {
            image = .init(id: asImage.id,
                          url: asImage.url,
                          type: .default,
                          position: 0)
        }
        
        return .init(id: self.id,
                     parent: self.parent?.id,
                     children: categories,
                     title: "",
                     description: self.description,
                     slug: self.slug,
                     link: self.link,
                     level: 1,
                     image: image,
                     images: [],
                     videos: [])
    }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Item: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        
        var image: WhoppahModel.Image? = nil
        
        if let asImage = self.media.compactMap({ $0.asImage }).first {
            image = .init(id: asImage.id,
                          url: asImage.url,
                          type: .default,
                          position: 0)
        }
        
        return .init(id: self.id,
                     parent: self.parent?.id,
                     title: "",
                     description: self.description,
                     slug: self.slug,
                     link: self.link,
                     level: 2,
                     image: image,
                     images: [],
                     videos: [])
    }
}

extension GraphQL.GetSubcategoriesQuery.Data.Subcategory: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        return .init(id: self.id,
                     parent: nil,
                     children: nil,
                     title: "",
                     description: nil,
                     slug: self.slug,
                     link: nil,
                     level: nil,
                     route: self.route,
                     showInStyles: nil,
                     showInBrands: nil,
                     image: self.avatarImage?.toWhoppahModel,
                     images: [],
                     video: nil,
                     videos: [])
    }
}

extension GraphQL.GetSubcategoriesQuery.Data.Subcategory.AvatarImage: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Image {
        .init(id: self.id,
              url: self.url,
              type: .avatar,
              orientation: nil,
              width: self.width,
              height: self.height,
              aspectRatio: nil,
              position: 0,
              backgroundColor: nil)
    }
}
