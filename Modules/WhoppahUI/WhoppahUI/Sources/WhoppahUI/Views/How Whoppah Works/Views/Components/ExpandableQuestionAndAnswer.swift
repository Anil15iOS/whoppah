//
//  ExpandableQuestionAndAnswer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import SwiftUI
import Combine

struct ExpandableQuestionAndAnswer: View {
    @State var isExpanded = false
    @State var isVisible = true
    
    let question: String
    let answer: String
    
    @Binding var searchTerm: String
    
    var body: some View {
        if $isVisible.wrappedValue {
            VStack(alignment: .leading, spacing: 30) {
                Text(question)
                .font(WhoppahTheme.Font.h2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                if $isExpanded.wrappedValue {
                    Text(html: answer,
                         size: 17,
                         fontFamily: WhoppahTheme.Font.Name.robotoRegular.rawValue)
                        .font(WhoppahTheme.Font.paragraph)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25))
                }
                Divider()
            }
            .valueChanged(value: $searchTerm.wrappedValue, onChange: { searchTerm in
                isVisible = shouldBeVisible(forSearchTerm: searchTerm)
            })
            .frame(maxWidth: .infinity)
            .onTapGesture {
                withAnimation {
                    $isExpanded.wrappedValue.toggle()
                }
            }
        } else {
            Color.clear
                .frame(width: 1, height: 1)
                .valueChanged(value: $searchTerm.wrappedValue, onChange: { searchTerm in
                    isVisible = shouldBeVisible(forSearchTerm: searchTerm)
                })
        }
    }
    
    private func shouldBeVisible(forSearchTerm searchTerm: String) -> Bool {
        if searchTerm.isEmpty { return true }
        
        let titleContainsSearchTerm = question.lowercased().contains(searchTerm.lowercased())
        let answerContainsSearchTerm = answer.lowercased().contains(searchTerm.lowercased())
        
        return titleContainsSearchTerm || answerContainsSearchTerm
    }
}

struct ExpandableQuestionAndAnswer_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableQuestionAndAnswer(question: "Question?",
                                    answer: Lipsum.randomParagraph,
                                    searchTerm: .constant(""))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
