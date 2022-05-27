//
//  StatsByOrderNo.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByOrderNo: Equatable {
	public let orderNo: Int
	public let avg: Double
	public let sum: Double
	public let count: Int

	public init(
		orderNo: Int,
		avg: Double,
		sum: Double,
		count: Int
	) {
		self.orderNo = orderNo
		self.avg = avg
		self.sum = sum
		self.count = count
	}
}
