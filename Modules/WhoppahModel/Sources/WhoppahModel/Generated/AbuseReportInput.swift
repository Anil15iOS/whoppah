//
//  AbuseReportInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AbuseReportInput {
	public let id: UUID
	public let type: AbuseReportType
	public let reason: AbuseReportReason
	public let description: String?

	public init(
		id: UUID,
		type: AbuseReportType,
		reason: AbuseReportReason,
		description: String? = nil
	) {
		self.id = id
		self.type = type
		self.reason = reason
		self.description = description
	}
}
