//
//  KeyboardEnabledView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import SwiftUI

struct KeyboardEnabledView<Content>: View where Content: View {
    private var content: Content
    private let doneButtonTitle: String
    private var keyboardSizeDidChange: ((CGFloat) -> Void)?
    
    @State private var isKeyboardVisible = false
    @State private var isViewActive = false
    @State private var keyboardHeight: CGFloat = 0
    
    public init(doneButtonTitle: String,
                @ViewBuilder content: () -> Content,
                keyboardSizeDidChange: ((CGFloat) -> Void)? = nil) {
        self.content = content()
        self.doneButtonTitle = doneButtonTitle
        self.keyboardSizeDidChange = keyboardSizeDidChange
    }
    
    var body: some View {
        let stack =
            ZStack {
                content
                
                KeyboardToolbar(doneButtonTitle: doneButtonTitle)
                    .isHidden(!isKeyboardVisible)
            }
            .onAppear { isViewActive = true }
            .onDisappear { isViewActive = false }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil), perform: { notification in
                guard isViewActive else { return }
                
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                else { return }

                keyboardHeight = keyboardRect.height
                keyboardSizeDidChange?(keyboardHeight)
                
                withAnimation {
                    isKeyboardVisible = true
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                guard isViewActive else { return }
                keyboardHeight = 0
                keyboardSizeDidChange?(keyboardHeight)
                withAnimation {
                    isKeyboardVisible = false
                }
            }
            stack
                .ignoresSafeArea(.keyboard)
    }
}

struct KeyboardEnabledView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardEnabledView(doneButtonTitle: "Done") {
            
        }
    }
}
