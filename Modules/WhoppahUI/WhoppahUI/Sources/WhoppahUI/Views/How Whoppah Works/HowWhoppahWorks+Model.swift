//
//  HowWhoppahWorks+Model.swift
//  
//
//  Created by Dennis Ippel on 08/11/2021.
//

import Foundation
import SwiftUI

public extension HowWhoppahWorks {
    struct Model: Equatable {
        public struct Section: Equatable, Hashable {
            let headerIconName: String?
            let title: String?
            let description: String?
            let additionalContent: AdditionalCustomContent?
            var ignorePadding: Bool = false
            
            public init(headerIconName: String? = nil,
                        title: String? = nil,
                        description: String? = nil,
                        additionalContent: AdditionalCustomContent? = nil,
                        ignorePadding: Bool = false)
            {
                self.headerIconName = headerIconName
                self.title = title
                self.description = description
                self.additionalContent = additionalContent
                self.ignorePadding = ignorePadding
            }
        }
        
        public struct Page: Equatable, Hashable {
            public init(pageId: String,
                        overviewTitle: String,
                        headerTitle: String,
                        longTitle: String,
                        overviewIconName: String,
                        iconName: String,
                        sectionBackgroundColor: Color,
                        sectionForegroundColor: Color,
                        sections: [HowWhoppahWorks.Model.Section])
            {
                self.pageId = pageId
                self.overviewTitle = overviewTitle
                self.headerTitle = headerTitle
                self.longTitle = longTitle
                self.overviewIconName = overviewIconName
                self.iconName = iconName
                self.sectionBackgroundColor = sectionBackgroundColor
                self.sectionForegroundColor = sectionForegroundColor
                self.sections = sections
            }
            
            let pageId: String
            let overviewTitle: String
            let headerTitle: String
            let longTitle: String
            let overviewIconName: String
            let iconName: String
            let sectionBackgroundColor: Color
            let sectionForegroundColor: Color
            let sections: [Section]
        }
        
        let title: String
        let pages: [Page]
        
        public init(title: String, pages: [Page]) {
            self.title = title
            self.pages = pages
        }
        
        static var initial = Self(title: "", pages: [])
        
        public class AdditionalCustomContent: Equatable, Hashable {
            public static func == (lhs: HowWhoppahWorks.Model.AdditionalCustomContent, rhs: HowWhoppahWorks.Model.AdditionalCustomContent) -> Bool {
                return lhs.id == rhs.id
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
            
            let id = UUID().uuidString
        }
        
        public class PaymentAdditionalContent: AdditionalCustomContent {
            let heroLogoName: String
            let paymentLogoNames: [String]
            
            public init(heroLogoName: String, paymentLogoNames: [String]) {
                self.heroLogoName = heroLogoName
                self.paymentLogoNames = paymentLogoNames
            }
        }
        
        public class CourierAdditionalContent: AdditionalCustomContent {
            public struct CourierOption: Hashable {
                let iconName: String
                let title: String
                let cost: String

                public init(iconName: String,
                            title: String,
                            cost: String)
                {
                    self.iconName = iconName
                    self.title = title
                    self.cost = cost
                }
            }
            
            public struct CallToAction {
                let iconName: String
                let backgroundColor: Color
                let foregroundColor: Color
                let title: String
                
                public init(iconName: String,
                            backgroundColor: Color,
                            foregroundColor: Color,
                            title: String)
                {
                    self.iconName = iconName
                    self.backgroundColor = backgroundColor
                    self.foregroundColor = foregroundColor
                    self.title = title
                }
            }
            
            let foregroundColor: Color
            let backgroundColor: Color
            let costLabelColor: Color
            let courierOptions: [CourierOption]
            var callToAction: CallToAction?
            
            public init(foregroundColor: Color,
                        backgroundColor: Color,
                        costLabelColor: Color,
                        courierOptions: [HowWhoppahWorks.Model.CourierAdditionalContent.CourierOption],
                        callToAction: CallToAction? = nil)
            {
                self.foregroundColor = foregroundColor
                self.backgroundColor = backgroundColor
                self.costLabelColor = costLabelColor
                self.courierOptions = courierOptions
                self.callToAction = callToAction
            }
        }
        
        public class PhotoQualityAdditionalContent: AdditionalCustomContent {
            let ctaIconName: String
            let ctaBackgroundColor: Color
            let ctaForegroundColor: Color
            let ctaTitle: String
            
            public init(ctaIconName: String,
                        ctaBackgroundColor: Color,
                        ctaForegroundColor: Color,
                        ctaTitle: String)
            {
                self.ctaIconName = ctaIconName
                self.ctaBackgroundColor = ctaBackgroundColor
                self.ctaForegroundColor = ctaForegroundColor
                self.ctaTitle = ctaTitle
            }
        }
        
        public class FAQAdditionalContent: AdditionalCustomContent {
            public struct QuestionAndAnswer: Hashable {
                let question: String
                let answer: String
                
                public init(question: String,
                            answer: String)
                {
                    self.question = question
                    self.answer = answer
                }
            }
            
            let searchBoxPlaceholderText: String
            let questionsAndAnswers: [QuestionAndAnswer]
            let contactTitle: String
            let emailIconName: String
            let emailDescription: String
            let phoneIconName: String
            let phoneDescription: String
            
            public init(searchBoxPlaceholderText: String,
                        questionsAndAnswers: [HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer],
                        contactTitle: String,
                        emailIconName: String,
                        emailDescription: String,
                        phoneIconName: String,
                        phoneDescription: String)
            {
                self.searchBoxPlaceholderText = searchBoxPlaceholderText
                self.questionsAndAnswers = questionsAndAnswers
                self.contactTitle = contactTitle
                self.emailIconName = emailIconName
                self.emailDescription = emailDescription
                self.phoneIconName = phoneIconName
                self.phoneDescription = phoneDescription
            }
        }
    }
}
