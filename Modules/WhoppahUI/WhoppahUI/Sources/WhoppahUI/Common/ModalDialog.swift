//
//  ModalDialog.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import SwiftUI

struct ModalDialog<Content>: View where Content: View {
    private var content: Content
    
    private var title: String
    private var description: String?
    private var iconName: String?
    
    private var onCloseButtonTapped: () -> Void
    
    public init(title: String,
                description: String? = nil,
                iconName: String? = nil,
                onCloseButtonTapped: @escaping () -> Void,
                @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.content = content()
        self.onCloseButtonTapped = onCloseButtonTapped
    }
    
    var body: some View {
        ZStack {
            WhoppahTheme.Color.base1.opacity(0.6)
                .onTapGesture(perform: onCloseButtonTapped)
            ZStack {
                VStack {
                    ZStack {
                        Image(iconName ?? "spark_green", bundle: .module)
                            .padding(.top, 40)
                        Button {
                            onCloseButtonTapped()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding(.all, 0)
                                .padding(.vertical, 16)
                                .padding(.leading, 16)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(WhoppahTheme.Font.h2)
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(height: 24)
                    
                    if let description = description, !description.isEmpty {
                        Text(description)
                            .multilineTextAlignment(.center)
                            .font(WhoppahTheme.Font.paragraph)
                            .frame(maxWidth: .infinity)
                        
                        Spacer().frame(height: 24)
                    }
                    
                    content
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .background(WhoppahTheme.Color.base4)
                .cornerRadius(6)
            }
            .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
            .padding(.horizontal, 16)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ModalDialog_Previews: PreviewProvider {
    static var previews: some View {
        ModalDialog(title: "Title",
                    description: "Description",
                    onCloseButtonTapped: {},
                    content: {})
    }
}
