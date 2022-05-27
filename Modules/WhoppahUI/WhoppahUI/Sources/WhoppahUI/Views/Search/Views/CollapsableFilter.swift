//
//  CollapsableFilter.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/03/2022.
//

import SwiftUI

struct CollapsableFilter<Content>: View where Content: View {
    @State private var isExpanded = true
    
    private var content: Content
    private var title: String
    
    init(title: String,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            
            HStack {
                Text(title)
                    .font(WhoppahTheme.Font.h3)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    WhoppahTheme.Color.base1.mask(
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .resizable()
                            .frame(width: 12, height: 7)
                    )
                    .frame(width: 12, height: 7)
                }
                .padding(.vertical, WhoppahTheme.Size.Padding.medium)
                .padding(.leading, WhoppahTheme.Size.Padding.medium)
                .padding(.trailing, WhoppahTheme.Size.Padding.small)
                .contentShape(Rectangle())
            }
            
            if isExpanded {
                content
                    .padding(.bottom, WhoppahTheme.Size.Padding.medium)
            }
        }
    }
}

struct CollapsableFilter_Previews: PreviewProvider {
    static var previews: some View {
        CollapsableFilter(title: "Title") {
            
        }
    }
}
