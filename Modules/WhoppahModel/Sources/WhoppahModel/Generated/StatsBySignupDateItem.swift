//
//  StatsBySignupDateItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsBySignupDateItem: Equatable {
	public let daterange: String
	public let today: StatsBySignupDateItemItem
	public let lastweek: StatsBySignupDateItemItem
	public let lastmonth: StatsBySignupDateItemItem
	public let lastquarter: StatsBySignupDateItemItem
	public let lasthalfyear: StatsBySignupDateItemItem
	public let lastyear: StatsBySignupDateItemItem

	public init(
		daterange: String,
		today: StatsBySignupDateItemItem,
		lastweek: StatsBySignupDateItemItem,
		lastmonth: StatsBySignupDateItemItem,
		lastquarter: StatsBySignupDateItemItem,
		lasthalfyear: StatsBySignupDateItemItem,
		lastyear: StatsBySignupDateItemItem
	) {
		self.daterange = daterange
		self.today = today
		self.lastweek = lastweek
		self.lastmonth = lastmonth
		self.lastquarter = lastquarter
		self.lasthalfyear = lasthalfyear
		self.lastyear = lastyear
	}
}
