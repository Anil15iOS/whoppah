//
//  MediaCellVIewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 21/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct MediaCellViewModel {
    enum ContentState {
        case empty
        case loading
        case photo(image: UIImage?)
        case video(thumb: UIImage?, video: Data?, path: URL?)
    }

    let state: ContentState
    let selectable: Bool
}
