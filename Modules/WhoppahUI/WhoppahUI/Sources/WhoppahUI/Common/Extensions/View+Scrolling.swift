//
//  File.swift
//  
//
//  Created by Dennis Ippel on 06/12/2021.
//

import SwiftUI

struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    
    private let showsIndicators: Bool
    private let axes: Axis.Set
    
    init(_ axes: Axis.Set, showsIndicators: Bool) {
        self.axes = axes
        self.showsIndicators = showsIndicators
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader {
                    Color.clear.preference(key: ScrollHeightPreferenceKey.self,
                                            value: $0.frame(in: .local).size.height)
                }
            )
            .onPreferenceChange(ScrollHeightPreferenceKey.self) {
                self.contentOverflow = $0 > geometry.size.height
            }
            .wrappedInScrollView(when: contentOverflow,
                                 axes: axes,
                                 showsIndicators: showsIndicators)
        }
    }
}

struct OverflowContentViewWithAdaptiveBounceModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    
    private let showsIndicators: Bool
    private let axes: Axis.Set
    
    init(_ axes: Axis.Set, showsIndicators: Bool) {
        self.axes = axes
        self.showsIndicators = showsIndicators
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader {
                    Color.clear.preference(key: ScrollHeightPreferenceKey.self,
                                            value: $0.frame(in: .local).size.height)
                }
            )
            .onPreferenceChange(ScrollHeightPreferenceKey.self) {
                self.contentOverflow = $0 > geometry.size.height
            }
            .wrappedInScrollView(axes: axes,
                                 showsIndicators: showsIndicators)
        }
    }
}

private struct ScrollHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

extension View {
    @ViewBuilder
    func wrappedInScrollView(when condition: Bool,
                             axes: Axis.Set,
                             showsIndicators: Bool) -> some View {
        if condition {
            ScrollView(axes, showsIndicators: showsIndicators) {
                self
            }
        } else {
            self
        }
    }
    
    @ViewBuilder
    func wrappedInScrollView(axes: Axis.Set,
                             showsIndicators: Bool) -> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            self
        }
        .onAppear { UIScrollView.appearance().bounces = false }
        .onDisappear { UIScrollView.appearance().bounces = true }
    }
}

extension View {
    func scrollOnOverflow(_ axes: Axis.Set, showsIndicators: Bool = true) -> some View {
        modifier(OverflowContentViewModifier(axes, showsIndicators: showsIndicators))
    }
    
    func scrollWithAdaptiveBounce(_ axes: Axis.Set, showsIndicators: Bool = true) -> some View {
        modifier(OverflowContentViewWithAdaptiveBounceModifier(axes, showsIndicators: showsIndicators))
    }
}
