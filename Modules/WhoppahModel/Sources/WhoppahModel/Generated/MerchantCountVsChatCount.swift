//
//  MerchantCountVsChatCount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantCountVsChatCount: Equatable {
	public let merchantCount: Int
	public let chatCount: Int

	public init(
		merchantCount: Int,
		chatCount: Int
	) {
		self.merchantCount = merchantCount
		self.chatCount = chatCount
	}
}
