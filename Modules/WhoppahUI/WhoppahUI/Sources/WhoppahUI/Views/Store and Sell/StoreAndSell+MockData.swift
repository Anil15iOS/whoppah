//  
//  StoreAndSell+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/12/2021.
//

import Foundation

public extension StoreAndSell.Model {
    static var mock: Self {
        let section1Points = [
            "We pick it up within 2 working days",
            "We bring it to the Whoppah Showroom in Utrecht",
            "We take professional photos and create and advertisement for you",
            "We store the item until it is sold or your book a return or pick it up yourself"
        ]
        let costItems = [
            CostItem(label: "Counter pick up", value: "€79"),
            CostItem(label: "We take professional photos, create the ad and show it in our showroom", value: "Free"),
            CostItem(label: "Commission fee", value: "25%")
        ]
        
        var qandas = [QAndA]()
        
        for i in 1..<6 {
            qandas.append(QAndA(question: "Question \(i)",
                                answer: "Answer \(i)"))
        }
        
        return Self(actionButtonTitle: "Request now",
                    title: "Sell your item from our showroom!",
                    subtitle: "We pick it up, make even better pictures and sell it for you.",
                    section1Title: "How does it work?",
                    section1Description: Lipsum.randomParagraph,
                    section1Points: section1Points,
                    costTitle: "Costs",
                    costItems: costItems,
                    questionsAndAnswers: qandas)
    }
}
