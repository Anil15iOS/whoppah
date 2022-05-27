//
//  Image+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/11/2021.
//

import SwiftUI

extension Image {
    func colorOverlay(_ color: Color) -> some View {
        return self.overlay(color.mask(self))
    }
}
