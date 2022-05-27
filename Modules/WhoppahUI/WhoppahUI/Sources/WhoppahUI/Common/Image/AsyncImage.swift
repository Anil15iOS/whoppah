//
//  AsyncImage.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 11/03/2022.
//

import SwiftUI

/*
 Loads an image asynchronously with caching support.
 
 Example usage:
 ~~~
 AsyncImage(url: item.imageUrl, enableCaching: true) {
     PlaceholderRectangle()
         .scaledToFit()
 } image: { image in
     image
         .resizable()
         .scaledToFit()
 }
 ~~~
 */
struct AsyncImage<Placeholder: View, FinalImage: View>: View {
    @StateObject private var loader: ImageLoader
    
    private let placeholder: Placeholder
    private let image: (Image) -> FinalImage
    private let crossFadeDuration: Double
    
    init(
        url: URL,
        crossFadeDuration: Double = 0.25,
        enableCaching: Bool = true,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> FinalImage)
    {
        self.placeholder = placeholder()
        self.image = image
        self.crossFadeDuration = crossFadeDuration
        _loader = StateObject(wrappedValue: ImageLoader(
            url: url,
            cache: enableCaching ? Environment(\.imageCache).wrappedValue : nil))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if let loadedImage = loader.image {
                image(Image(uiImage: loadedImage))
                    .transition(.opacity.animation(
                        .easeInOut(duration: crossFadeDuration)))
            } else {
                placeholder
                    .transition(.opacity.animation(
                        .easeInOut(duration: crossFadeDuration)))
            }
        }
    }
}
