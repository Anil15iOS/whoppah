//
//  TranslationResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct TranslationResult: Equatable {
	public let translatedtext: String
	public let detectedsourcelanguage: String

	public init(
		translatedtext: String,
		detectedsourcelanguage: String
	) {
		self.translatedtext = translatedtext
		self.detectedsourcelanguage = detectedsourcelanguage
	}
}
