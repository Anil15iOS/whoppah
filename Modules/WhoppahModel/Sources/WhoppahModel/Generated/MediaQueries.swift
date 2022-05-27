//
//  MediaQueries.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public protocol MediaQueries {
	var image: Image? { get }
	var images: [Image] { get }
	var video: Video? { get }
	var videos: [Video] { get }
}
