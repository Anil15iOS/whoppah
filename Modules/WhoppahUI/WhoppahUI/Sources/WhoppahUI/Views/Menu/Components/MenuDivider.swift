//
//  MenuDivider.swift
//  
//
//  Created by Dennis Ippel on 25/11/2021.
//

import SwiftUI

struct MenuDivider: View {
    var body: some View {
        Divider()
            .background(WhoppahTheme.Color.base3)
    }
}

struct MenuDivider_Previews: PreviewProvider {
    static var previews: some View {
        MenuDivider()
    }
}
