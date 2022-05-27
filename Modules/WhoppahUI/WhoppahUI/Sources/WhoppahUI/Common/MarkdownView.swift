//
//  MarkdownView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/05/2022.
//

import SwiftUI

// Warning: Only supports a very small subset. Will add more when required.
public struct MarkdownView: View {
    public enum Action {
        case didTapLink(url: String)
    }
    
    private var stringsWithActions = [StringWithOptionalAction<Action>]()
    private let textColor: Color
    private let linkColor: Color
    private let font: Font
    private let didEmitAction: (Action) -> Void
    
    public init(markdown: String,
                textColor: Color = WhoppahTheme.Color.base1,
                linkColor: Color = WhoppahTheme.Color.alert2,
                font: Font = WhoppahTheme.Font.paragraph,
                didEmitAction: @escaping (Action) -> Void)
    {
        self.textColor = textColor
        self.linkColor = linkColor
        self.font = font
        self.didEmitAction = didEmitAction
        
        parseMarkdown(markdown)
    }
    
    public var body: some View {
        StringsWithOptionalActionsFlowLayout(stringsWithActions,
                                             textColor: textColor,
                                             actionColor: linkColor,
                                             font: font) { action in
            didEmitAction(action)
        }
    }
    
    mutating private func parseMarkdown(_ markdown: String) {
        enum TextType {
            case regular
            case bold
            case italic
            case linkText
            case linkURL
        }
        
        var currentString = ""
        var currentType = TextType.regular
        var ignoreNext = false
        
        for i in 0..<markdown.count {
            if ignoreNext {
                ignoreNext = false
                continue
            }
            
            let character = markdown[i]
            let nextCharacter = i < markdown.count ? markdown[i + 1] : .empty
            
            switch character {
            case "*":
                if nextCharacter == "*" {
                    if currentType == .bold {
                        stringsWithActions.append(
                            .init(
                                text: currentString,
                                action: nil,
                                textColor: linkColor,
                                fontWeight: .bold))
                        ignoreNext = true
                        currentType = .regular
                        currentString = ""
                    } else {
                        if !currentString.isEmpty {
                            stringsWithActions.append(.init(text: currentString, action: nil))
                        }
                        ignoreNext = true
                        currentString = ""
                        currentType = .bold
                    }
                } else {
                    currentString += character
                }
            case "_":
                if nextCharacter == "_" {
                    if currentType == .italic {
                        stringsWithActions.append(
                            .init(
                                text: currentString,
                                action: nil,
                                textColor: linkColor,
                                italic: true))
                        ignoreNext = true
                        currentType = .regular
                        currentString = ""
                    } else {
                        if !currentString.isEmpty {
                            stringsWithActions.append(.init(text: currentString, action: nil))
                        }
                        ignoreNext = true
                        currentString = ""
                        currentType = .italic
                    }
                } else {
                    currentString += character
                }
            case "[":
                currentType = .linkText
            case "]":
                if i < markdown.count - 2 {
                    let startIndex = i + 2
                    var urlString = markdown.substring(fromIndex: startIndex)
                    if let endIndex = urlString.firstIndex(of: ")") {
                        let index = urlString.distance(from: urlString.startIndex, to: endIndex)
                        urlString = urlString.substring(toIndex: index)
                        
                        stringsWithActions.append(
                            .init(text: currentString,
                                  action: .didTapLink(url: urlString))
                        )
                        currentString = ""
                        currentType = .linkURL
                    }
                }
            case ")":
                if currentType == .linkURL {
                    currentString = ""
                    continue
                }
                currentString += character
            case " ":
                if !currentString.isEmpty && currentType != .linkText {
                    stringsWithActions.append(.init(text: currentString + " ",
                                                    action: nil,
                                                    fontWeight: currentType == .bold ? .bold : .regular,
                                                    italic: currentType == .italic))
                    currentString = ""
                } else {
                    currentString += character
                }
            default:
                currentString += character
            }
        }
        
        if !currentString.isEmpty {
            stringsWithActions.append(.init(text: currentString,
                                            action: nil))
        }
    }
}
