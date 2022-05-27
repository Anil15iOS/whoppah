//
//  Lipsum.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import Foundation
import simd

public struct Lipsum {
    private static let paragraphs = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ac mauris at elit accumsan pellentesque id sed sem. Morbi ornare diam turpis, a aliquet libero pellentesque quis. Nullam gravida turpis quam. Nunc eros mi, faucibus non fermentum ut, varius eget tellus. Nunc fermentum a odio sed commodo. Nulla facilisi. Morbi tincidunt lorem tortor, eget ultricies orci auctor a.",
        "Aliquam rutrum maximus dui, ac vestibulum eros pretium at. Maecenas rutrum sem in neque fermentum, sed ultricies sem bibendum. Morbi efficitur dictum lacinia. Phasellus sit amet volutpat turpis, sed fermentum velit. Pellentesque scelerisque non massa pulvinar ullamcorper. Quisque sit amet turpis nisi. Morbi vulputate justo in felis fringilla venenatis.",
        "Praesent sit amet venenatis arcu. Pellentesque dictum odio mi. Nunc ac erat ex. Nullam quis tellus ultricies, interdum velit vitae, posuere sem. Ut semper mi eget ex tempor, vitae porttitor sapien sodales. Integer consequat mollis justo eu feugiat. Nam laoreet viverra dapibus. Nullam at massa velit. In sed semper augue.",
        "Aliquam rutrum maximus dui, ac vestibulum eros pretium at. Maecenas rutrum sem in neque fermentum, sed ultricies sem bibendum. Morbi efficitur dictum lacinia. Phasellus sit amet volutpat turpis, sed fermentum velit. Pellentesque scelerisque non massa pulvinar ullamcorper. Quisque sit amet turpis nisi. Morbi vulputate justo in felis fringilla venenatis.",
        "Vivamus molestie ac ligula a dapibus. Vestibulum varius, ante a vulputate pharetra, ipsum nibh auctor magna, sit amet dignissim nisl dui at est. Nulla facilisi. Interdum et malesuada fames ac ante ipsum primis in faucibus."
        ]
    
    public static var randomParagraph: String {
        return paragraphs.randomElement() ?? ""
    }
    
    public static func random(numberOfParagraphs: Int, joinSeparator: String = "\n") -> String {
        let count = min(numberOfParagraphs, paragraphs.count)
        
        var randomParagraphs = [String]()
        
        for _ in 0..<count {
            randomParagraphs.append(paragraphs.randomElement() ?? "")
        }
        
        return randomParagraphs.joined(separator: joinSeparator)
    }
}
