//
//  StickyFooter.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/02/2022.
//

import SwiftUI

struct StickyFooter<Content>: View where Content: View {
    private var content: Content
    private var onSizeChange: (CGSize) -> Void
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    public init(@ViewBuilder content: () -> Content,
                onSizeChange: @escaping (CGSize) -> Void) {
        self.content = content()
        self.onSizeChange = onSizeChange
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                content
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .padding(.bottom, safeAreaInsets.bottom)
            .background(GeometryReader { geometryProxy in
                WhoppahTheme.Color.base4
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            })
            .shadow(color: WhoppahTheme.Color.support8, radius: 20, x: 0, y: 0)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
        .onPreferenceChange(SizePreferenceKey.self, perform: onSizeChange)
    }
}

struct StickyFooter_Previews: PreviewProvider {
    static var previews: some View {
        StickyFooter {
            
        } onSizeChange: { _ in
            
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
