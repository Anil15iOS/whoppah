//  
//  StoreAndSell+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/12/2021.
//

import Foundation
import SwiftUI

public extension StoreAndSell {
    struct Model: Equatable {
        public struct CostItem: Equatable, Hashable {
            public let uuid = UUID()
            
            public let label: String
            public let value: String
            
            public init(label: String, value: String) {
                self.label = label
                self.value = value
            }
            
            public static func == (lhs: CostItem, rhs: CostItem) -> Bool {
                return lhs.uuid == rhs.uuid
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(uuid.uuidString)
            }
        }
        
        public struct QAndA: Equatable, Hashable {
            public let uuid = UUID()
            
            public let question: String
            public let answer: String
            
            public init(question: String, answer: String) {
                self.question = question
                self.answer = answer
            }
            
            public static func == (lhs: QAndA, rhs: QAndA) -> Bool {
                return lhs.uuid == rhs.uuid
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(uuid.uuidString)
            }
        }
        
        let actionButtonTitle: String
        let title: String
        let subtitle: String
        let section1Title: String
        let section1Description: String
        let section1Points: [String]
        let costTitle: String
        let costItems: [CostItem]
        let questionsAndAnswers: [QAndA]
        
        public static var initial = Self(actionButtonTitle: "",
                                  title: "",
                                  subtitle: "",
                                  section1Title: "",
                                  section1Description: "",
                                  section1Points: [],
                                  costTitle: "",
                                  costItems: [],
                                  questionsAndAnswers: [])
        
        public init(actionButtonTitle: String,
                    title: String,
                    subtitle: String,
                    section1Title: String,
                    section1Description: String,
                    section1Points: [String],
                    costTitle: String,
                    costItems: [CostItem],
                    questionsAndAnswers: [QAndA])
        {
            self.actionButtonTitle = actionButtonTitle
            self.title = title
            self.subtitle = subtitle
            self.section1Title = section1Title
            self.section1Description = section1Description
            self.section1Points = section1Points
            self.costTitle = costTitle
            self.costItems = costItems
            self.questionsAndAnswers = questionsAndAnswers
        }
    }
}
