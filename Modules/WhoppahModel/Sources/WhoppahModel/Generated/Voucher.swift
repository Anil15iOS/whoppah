//
//  Voucher.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Voucher: Equatable {
	public let code: String
	public let validUpto: Date?

	public init(
		code: String,
		validUpto: Date? = nil
	) {
		self.code = code
		self.validUpto = validUpto
	}
}
