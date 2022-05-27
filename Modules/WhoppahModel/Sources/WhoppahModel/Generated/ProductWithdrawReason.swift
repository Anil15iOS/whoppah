//
//  ProductWithdrawReason.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum ProductWithdrawReason: String, CaseIterable {
	case soldWhoppah
	case soldElsewhere
	case soldEbay
	case soldPamono
	case soldSelency
	case sold1Stdibs
	case soldMarktplaats
	case soldTweedehands
	case expiredNoResponse
	case noLongerSelling
	case leavingWhoppah
	case other
	case unknown
}
