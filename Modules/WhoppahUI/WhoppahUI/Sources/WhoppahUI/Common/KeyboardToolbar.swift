//
//  KeyboardToolbar.swift
//  
//
//  Created by Dennis Ippel on 23/12/2021.
//

import SwiftUI

struct KeyboardToolbar: View {
    let doneButtonTitle: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(doneButtonTitle, action: {
                    UIApplication.shared.closeKeyboard()
                })
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .background(WhoppahTheme.Color.base3)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .transition(.opacity)
    }
}

struct KeyboardToolbar_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardToolbar(doneButtonTitle: "Done")
    }
}
