//
//  ModalPopUpView.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 21.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture

public struct ModalPopUpView: View {
    
    @Binding private var show: Bool
    @Binding private var content: ModalPopupContent
    
    public typealias DidTapCloseClosure = () -> Void
    private let didTapCloseButton: DidTapCloseClosure

    public init(content: Binding<ModalPopupContent>,
                showPopup: Binding<Bool>,
                didTapCloseButton: @escaping DidTapCloseClosure = {}) {
        self._content = content
        self._show = showPopup
        self.didTapCloseButton = didTapCloseButton
    }
    
    public var body: some View {
        ZStack {
            if show {
                Color.black.opacity(show ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            didTapCloseButton()
                            withAnimation(.linear(duration: 0.1)) {
                                show = false
                            }
                        } label: {
                            Image("close-small", bundle: .module)
                        }
                        .padding([.trailing, .top], WhoppahTheme.Size.Padding.extraLarge)
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text(content.title)
                                .foregroundColor(WhoppahTheme.Color.base1)
                                .font(WhoppahTheme.Font.h2)
                                .padding([.leading, .trailing], WhoppahTheme.Size.Padding.extraMedium)
                                .padding(.bottom, WhoppahTheme.Size.Padding.extraMedium)
                            
                            ForEach(content.contentItems) { contentItem in
                                switch contentItem {
                                case let paragraph as ModalPopupContent.ParagraphItem:
                                    
                                    //
                                    // 📘 Paragraph
                                    //
                                    
                                    if let title = paragraph.title {
                                        Text(title)
                                            .foregroundColor(WhoppahTheme.Color.base1)
                                            .font(WhoppahTheme.Font.h3)
                                            .padding(.bottom, 0)
                                    }
                                        
                                    Text(paragraph.content)
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                        .font(WhoppahTheme.Font.subtitle)
                                        .padding(.all, WhoppahTheme.Size.Padding.extraMedium)
                                        .padding(.bottom, WhoppahTheme.Size.Padding.small)
                                case let bulletPoint as ModalPopupContent.BulletPointItem:
                                    
                                    //
                                    // 🔫 Bullet Point
                                    //
                                    
                                    HStack(alignment: .top) {
                                        Image(bulletPoint.iconName, bundle: .module)
                                        Text(bulletPoint.content)
                                            .foregroundColor(WhoppahTheme.Color.base1)
                                            .font(WhoppahTheme.Font.subtitle)
                                            .frame(maxWidth: .infinity,
                                                   alignment: .leading)
                                    }
                                    .padding(.horizontal, WhoppahTheme.Size.Padding.extraMedium)
                                    .padding(.vertical, WhoppahTheme.Size.Padding.smaller)
                                    
                                case _ as ModalPopupContent.DividerItem:
                                    
                                    //
                                    // 🔪 Divider
                                    //
                                    
                                    Divider()
                                        .padding(.horizontal, WhoppahTheme.Size.Padding.extraMedium)
                                        .padding(.vertical, WhoppahTheme.Size.Padding.medium)
                                    
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    
                    CallToAction(backgroundColor: Color.white,
                                 foregroundColor: WhoppahTheme.Color.base1,
                                 iconName: nil,
                                 title: content.goBackButtonTitle,
                                 showBorder: true)
                    {
                        didTapCloseButton()
                        withAnimation(.linear(duration: 0.2)) {
                            show = false
                        }
                    }
                    .padding(.all, WhoppahTheme.Size.Padding.extraMedium)
                }
                .background(Color.white)
                .cornerRadius(WhoppahTheme.Size.Radius.small)
                .padding([.leading, .trailing], WhoppahTheme.Size.Padding.regularMedium)
                .padding([.top, .bottom], WhoppahTheme.Size.Padding.large)
            }
        }
    }
}

struct ModalPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        ModalPopUpView(content: .constant(.initial),
                       showPopup: .constant(true))
    }
}
