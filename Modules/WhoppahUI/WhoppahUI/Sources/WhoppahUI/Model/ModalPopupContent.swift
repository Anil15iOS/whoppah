//
//  ModalPopupContent.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/05/2022.
//

import Foundation

public class ModalPopupContentItem: Identifiable {
    public let id = UUID()
}

public struct ModalPopupContent: Equatable {
    public static func == (lhs: ModalPopupContent, rhs: ModalPopupContent) -> Bool {
        lhs.title == rhs.title &&
        lhs.contentItems.count == rhs.contentItems.count &&
        lhs.goBackButtonTitle == rhs.goBackButtonTitle
    }
    
    public class ParagraphItem: ModalPopupContentItem {
        let title: String?
        let content: String
        let leadingIconName: String?
        
        public init(title: String? = nil,
                    content: String,
                    leadingIconName: String? = nil)
        {
            self.title = title
            self.content = content
            self.leadingIconName = leadingIconName
        }
    }
    
    public class DividerItem: ModalPopupContentItem {
        public override init() {
            super.init()
        }
    }
    
    public class BulletPointItem: ModalPopupContentItem {
        let iconName: String
        let content: String
        
        public init(iconName: String,
                    content: String)
        {
            self.iconName = iconName
            self.content = content
        }
    }
    
    let title: String
    let contentItems: [ModalPopupContentItem]
    let goBackButtonTitle: String
    
    public static var initial = Self(
        title: "",
        contentItems: [],
        goBackButtonTitle: "")
    
    public init(title: String,
                contentItems: [ModalPopupContentItem],
                goBackButtonTitle: String)
    {
        self.title = title
        self.contentItems = contentItems
        self.goBackButtonTitle = goBackButtonTitle
    }
}
