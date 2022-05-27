//
//  MerchantCountVsProductCount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantCountVsProductCount: Equatable {
	public let merchantCount: Int
	public let productCount: Int

	public init(
		merchantCount: Int,
		productCount: Int
	) {
		self.merchantCount = merchantCount
		self.productCount = productCount
	}
}
