//
//  SellerCountVsOrderCount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SellerCountVsOrderCount: Equatable {
	public let sellerCount: Int
	public let orderCount: Int

	public init(
		sellerCount: Int,
		orderCount: Int
	) {
		self.sellerCount = sellerCount
		self.orderCount = orderCount
	}
}
