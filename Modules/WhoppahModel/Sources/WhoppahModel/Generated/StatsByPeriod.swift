//
//  StatsByPeriod.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByPeriod: Equatable {
	public let today: StatsByPeriodItem?
	public let yesterday: StatsByPeriodItem?
	public let lastweek: StatsByPeriodItem?
	public let lastmonth: StatsByPeriodItem?
	public let lastquarter: StatsByPeriodItem?
	public let lastyear: StatsByPeriodItem?
	public let monthtodate: StatsByPeriodItem?
	public let quartertodate: StatsByPeriodItem?
	public let yeartodate: StatsByPeriodItem?
	public let lifetime: StatsByPeriodItem?

	public init(
		today: StatsByPeriodItem? = nil,
		yesterday: StatsByPeriodItem? = nil,
		lastweek: StatsByPeriodItem? = nil,
		lastmonth: StatsByPeriodItem? = nil,
		lastquarter: StatsByPeriodItem? = nil,
		lastyear: StatsByPeriodItem? = nil,
		monthtodate: StatsByPeriodItem? = nil,
		quartertodate: StatsByPeriodItem? = nil,
		yeartodate: StatsByPeriodItem? = nil,
		lifetime: StatsByPeriodItem? = nil
	) {
		self.today = today
		self.yesterday = yesterday
		self.lastweek = lastweek
		self.lastmonth = lastmonth
		self.lastquarter = lastquarter
		self.lastyear = lastyear
		self.monthtodate = monthtodate
		self.quartertodate = quartertodate
		self.yeartodate = yeartodate
		self.lifetime = lifetime
	}
}
