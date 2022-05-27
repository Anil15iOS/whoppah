//
//  StoreAndSell+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 13/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization

extension StoreAndSell.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        let section1Points = [
            l.storage_page_section_1_point_1(),
            l.storage_page_section_1_point_2(),
            l.storage_page_section_1_point_3(),
            l.storage_page_section_1_point_4()
        ]
        
        let costItems = [
            CostItem(label: l.storage_page_cost_item_label_1(),
                     value: l.storage_page_cost_item_value_1()),
            CostItem(label: l.storage_page_cost_item_label_2(),
                     value: l.storage_page_cost_item_value_2()),
            CostItem(label: l.storage_page_cost_item_label_3(),
                     value: l.storage_page_cost_item_value_3())
        ]
        
        let questionsAndAnswers = [
            QAndA(question: l.storage_page_section2_question_1(),
                  answer: l.storage_page_section2_answer_1()),
            QAndA(question: l.storage_page_section2_question_2(),
                  answer: l.storage_page_section2_answer_2()),
            QAndA(question: l.storage_page_section2_question_3(),
                  answer: l.storage_page_section2_answer_3()),
            QAndA(question: l.storage_page_section2_question_4(),
                  answer: l.storage_page_section2_answer_4()),
            QAndA(question: l.storage_page_section2_question_5(),
                  answer: l.storage_page_section2_answer_5()),

            QAndA(question: l.storage_page_section3_question_1(),
                  answer: l.storage_page_section3_answer_1()),
            QAndA(question: l.storage_page_section3_question_2(),
                  answer: l.storage_page_section3_answer_2()),
            QAndA(question: l.storage_page_section3_question_3(),
                  answer: l.storage_page_section3_answer_3()),
            QAndA(question: l.storage_page_section3_question_4(),
                  answer: l.storage_page_section3_answer_4())
        ]
        
        let content = StoreAndSell.Model(actionButtonTitle: l.storage_page_action_button(),
                                         title: l.storage_page_title(),
                                         subtitle: l.storage_page_subtitle(),
                                         section1Title: l.storage_page_section1_title(),
                                         section1Description: l.storage_page_section1_description(),
                                         section1Points: section1Points,
                                         costTitle: l.storage_page_cost_title(),
                                         costItems: costItems,
                                         questionsAndAnswers: questionsAndAnswers)
        
        return content
    }
}
