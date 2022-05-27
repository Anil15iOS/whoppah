//
//  StringsWithOptionalActionsFlowLayout.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI

struct StringWithOptionalAction<T>: Equatable, Hashable {
    let id = UUID()
    let text: String
    let action: T?
    let font: Font?
    let textColor: Color?
    let fontWeight: Font.Weight
    let italic: Bool
    
    init(text: String,
         action: T?,
         font: Font? = nil,
         textColor: Color? = nil,
         fontWeight: Font.Weight = .regular,
         italic: Bool = false)
    {
        self.text = text
        self.action = action
        self.font = font
        self.textColor = textColor
        self.fontWeight = fontWeight
        self.italic = italic
    }
    
    public static func == (lhs: StringWithOptionalAction, rhs: StringWithOptionalAction) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct StringsWithOptionalActionsFlowLayout<T>: View {
    let values: [StringWithOptionalAction<T>]
    let textColor: Color
    let actionColor: Color
    let font: Font
    let didTapText: (T) -> Void
    
    init(_ values: [StringWithOptionalAction<T>],
         textColor: Color = WhoppahTheme.Color.base1,
         actionColor: Color = WhoppahTheme.Color.alert3,
         font: Font = WhoppahTheme.Font.caption,
         didTapText: @escaping (T) -> Void) {
        self.values = values
        self.font = font
        self.textColor = textColor
        self.actionColor = actionColor
        self.didTapText = didTapText
    }
    
    var body: some View {
        FlowLayout(mode: .scrollable,
                   binding: .constant(3),
                   items: values) { item, isLastItem in
            buildText(item)
        }
    }
    
    private func font(value: StringWithOptionalAction<T>) -> Font {
        var font = value.font ?? font
        font = font.weight(value.fontWeight)
        if value.italic {
            font = font.italic()
        }
        return font
    }
    
    @ViewBuilder func buildText(_ value: StringWithOptionalAction<T>) -> some View {
        if let action = value.action {
            Text(value.text)
            .font(font(value: value))
            .foregroundColor(actionColor)
            .contentShape(Rectangle())
            .onTapGesture {
                didTapText(action)
            }
        } else {
            Text(value.text)
                .font(font(value: value))
                .foregroundColor(textColor)
        }
    }
}
