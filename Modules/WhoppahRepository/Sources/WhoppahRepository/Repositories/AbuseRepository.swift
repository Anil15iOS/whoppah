//
//  AbuseRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 04/05/2022.
//

import Foundation
import Combine
import WhoppahModel

public protocol AbuseRepository {
    func reportAbuse(_ input: AbuseReportInput) -> AnyPublisher<Bool, Error>
}
