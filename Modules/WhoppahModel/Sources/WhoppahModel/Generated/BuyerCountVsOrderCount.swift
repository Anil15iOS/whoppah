//
//  BuyerCountVsOrderCount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct BuyerCountVsOrderCount: Equatable {
	public let buyerCount: Int
	public let orderCount: Int

	public init(
		buyerCount: Int,
		orderCount: Int
	) {
		self.buyerCount = buyerCount
		self.orderCount = orderCount
	}
}
