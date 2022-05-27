//
//  StatsBySignupDate.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsBySignupDate: Equatable {
	public let buyer: [StatsBySignupDateItem]
	public let seller: [StatsBySignupDateItem]

	public init(
		buyer: [StatsBySignupDateItem],
		seller: [StatsBySignupDateItem]
	) {
		self.buyer = buyer
		self.seller = seller
	}
}
