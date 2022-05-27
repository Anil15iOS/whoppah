//
//  ForgotPasswordResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum ForgotPasswordResult: String, CaseIterable {
	case emailSent
	case emailNotFound
	case unknown
}
