//
//  AdPhoto.swift
//  Whoppah
//
//  Created by Eddie Long on 11/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

enum AdPhoto {
    /// New - not yet uploaded to the server
    case new(data: UIImage)
    /// Already exists on the server, may not have data downloaded yet
    case existing(id: UUID, data: UIImage?)

    func image() -> UIImage? {
        switch self {
        case let .new(data):
            return data
        case let .existing(_, data):
            return data
        }
    }

    func id() -> UUID? {
        switch self {
        case .new:
            return nil
        case let .existing(id, _):
            return id
        }
    }
}
