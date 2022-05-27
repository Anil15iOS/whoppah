//
//  StatsAdsAndSignups.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsAdsAndSignups: Equatable {
	public let date: String
	public let signups: Int
	public let ads: Int

	public init(
		date: String,
		signups: Int,
		ads: Int
	) {
		self.date = date
		self.signups = signups
		self.ads = ads
	}
}
