//
//  ScrollViewOffset.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 4.4.22..
//

import SwiftUI

struct ScrollViewOffset<Content>: View where Content: View {
    
    @Binding private var scrollToViewEnabled: Bool
    private var uniqueViewId: UUID
    private var content: Content
    private var onOffsetChange: (CGFloat) -> Void
    private let scrollUniqueName = "scroll"
                
    public init(scrollToViewEnabled: Binding<Bool>,
                uniqueViewId: UUID,
                @ViewBuilder content: () -> Content,
                onOffsetChange: @escaping (CGFloat) -> Void) {
        self.content = content()
        self.onOffsetChange = onOffsetChange
        self._scrollToViewEnabled = scrollToViewEnabled
        self.uniqueViewId = uniqueViewId
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { value in
                VStack {
                    self.content
                }
                .onChange(of: scrollToViewEnabled, perform: { newValue in
                    withAnimation {
                        value.scrollTo(self.uniqueViewId, anchor: .center)
                    }
                })
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                                           value: -$0.frame(in: .named(self.scrollUniqueName)).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) {
                    self.onOffsetChange($0)
                }
            }
        }
        .coordinateSpace(name: self.scrollUniqueName)
        
    }
}

private struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value,
                       nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ScrollViewOffset_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewOffset(scrollToViewEnabled: .constant(false),
                         uniqueViewId: UUID(),
                         content: {},
                         onOffsetChange: {_ in })
    }
}
