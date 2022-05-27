//
//  NavigationStackViewWithHeader.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 31/01/2022.
//

import SwiftUI

public struct NavigationStackViewWithHeader<Content>: View where Content: View {
    private let content: Content
    private let navigationStack: NavigationStack
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    @Binding private var headerTitle: String
    
    private var didTapCloseButton: (() -> Void)?
    
    public init(navigationStack: NavigationStack,
                headerTitle: Binding<String>,
                didTapCloseButton: (() -> Void)? = nil,
                @ViewBuilder content: () -> Content)
    {
        self.content = content()
        self._headerTitle = headerTitle
        self.didTapCloseButton = didTapCloseButton
        self.navigationStack = navigationStack
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack {
                    Text(headerTitle)
                        .font(WhoppahTheme.Font.h3)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Button {
                            if navigationStack.depth == 0 {
                                didTapCloseButton?()
                            } else {
                                navigationStack.pop()
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(WhoppahTheme.Color.base1)
                                .frame(width: WhoppahTheme.Size.NavBar.backButtonSize,
                                       height: WhoppahTheme.Size.NavBar.backButtonSize)
                        }
                        .padding(WhoppahTheme.Size.Padding.small)
                        .contentShape(Rectangle())

                        Spacer()
                    }
                }
                .padding(.top, safeAreaInsets.top)
                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                .frame(height: WhoppahTheme.Size.NavBar.height)
                .background(WhoppahTheme.Color.base4)

                Rectangle()
                    .fill(Color(hex: "#C6C6C8"))
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                    .frame(maxWidth: .infinity)
            }
            .edgesIgnoringSafeArea(.top)
            
            GeometryReader { geom in
                ZStack {
                    NavigationStackView(navigationStack: navigationStack) {
                        content
                    }
                    .frame(maxWidth: .infinity,
                           minHeight: geom.size.height,
                           maxHeight: UIScreen.main.bounds.height - WhoppahTheme.Size.NavBar.height)
                }
                .frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
