//
//  HowWhoppahWorksFAQContent.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI

struct HowWhoppahWorksFAQContent: View {
    let content: HowWhoppahWorks.Model.FAQAdditionalContent
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBox(searchText: $searchText,
                      backgroundColor: WhoppahTheme.Color.base4,
                      foregroundColor: WhoppahTheme.Color.base2,
                      placeholderText: content.searchBoxPlaceholderText)
            Spacer()
                .frame(height: 40)
            Divider()
            ForEach(0..<content.questionsAndAnswers.count, id: \.self) { i in
                let qa = content.questionsAndAnswers[i]
                ExpandableQuestionAndAnswer(isExpanded: false,
                                            question: qa.question,
                                            answer: qa.answer,
                                            searchTerm: $searchText)
            }
            Text(content.contactTitle)
                .font(WhoppahTheme.Font.h3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
            HStack(alignment: .top, spacing: 16) {
                Image(content.emailIconName, bundle: .module)
                Text(content.emailDescription)
                    .font(WhoppahTheme.Font.paragraph)
            }
            HStack(alignment: .top, spacing: 16) {
                Image(content.phoneIconName, bundle: .module)
                Text(content.phoneDescription)
                    .font(WhoppahTheme.Font.paragraph)
            }
        }
    }
}

struct HowWhoppahWorksFAQFooter_Previews: PreviewProvider {
    static var previews: some View {
        HowWhoppahWorksFAQContent(
            content: HowWhoppahWorks.Model.FAQAdditionalContent(
                searchBoxPlaceholderText: "We are here to help :)",
                questionsAndAnswers: [
                    HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer(question: "Question 1", answer: Lipsum.randomParagraph),
                    HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer(question: "Question 2", answer: Lipsum.randomParagraph),
                    HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer(question: "Question 3", answer: Lipsum.randomParagraph),
                    HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer(question: "Question 4", answer: Lipsum.randomParagraph),
                    HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer(question: "Question 5", answer: Lipsum.randomParagraph),
                    HowWhoppahWorks.Model.FAQAdditionalContent.QuestionAndAnswer(question: "Question 6", answer: Lipsum.randomParagraph)
                 ],
                 contactTitle: "We are here to help",
                 emailIconName: "contact_email_icon",
                 emailDescription: "Do you have a question? Send an email to the Whoppah Support team and we will get back to you as soon as possible: support@whoppah.com",
                 phoneIconName: "contact_phone_icon",
                 phoneDescription: "Whoppah is available Monday to Friday during office hours on: +31 (0) 20 244 46 93.")
        )
    }
}
