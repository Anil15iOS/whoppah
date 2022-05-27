//
//  NumericStepperWithTextInput.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/04/2022.
//

import SwiftUI

struct NumericStepperWithTextInput: View {
    private let borderColor: Color
    private let backgroundColor: Color
    private let minValue: Int
    private let maxValue: Int
    private let increment: Int
    
    @Binding private var currentValue: Int
    
    init(borderColor: Color = WhoppahTheme.Color.base2,
         backgroundColor: Color = WhoppahTheme.Color.base4,
         minValue: Int = 0,
         maxValue: Int = 100,
         increment: Int = 1,
         currentValue: Binding<Int>)
    {
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.minValue = minValue
        self.maxValue = maxValue
        self.increment = increment
        self._currentValue = currentValue
    }
    
    var body: some View {
        HStack(spacing: 1) {
            Button {
                currentValue = max(currentValue - increment, minValue)
            } label: {
                Image(systemName: "minus")
                    .colorOverlay(borderColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .background(backgroundColor)
            
            Text("\(currentValue)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
            
            Button {
                currentValue = min(currentValue + increment, maxValue)
            } label: {
                Image(systemName: "plus")
                    .colorOverlay(borderColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
        }
        .frame(width: WhoppahTheme.Size.NumericStepper.width,
               height: WhoppahTheme.Size.NumericStepper.height)
        .background(borderColor)
        .mask(RoundedRectangle(cornerRadius: WhoppahTheme.Size.NumericStepper.cornerRadius))
        .overlay(RoundedRectangle(cornerRadius: WhoppahTheme.Size.NumericStepper.cornerRadius)
            .stroke(borderColor))
    }
}

struct NumericStepperWithTextInput_Previews: PreviewProvider {
    static var previews: some View {
        NumericStepperWithTextInput(currentValue: .constant(1))
    }
}
