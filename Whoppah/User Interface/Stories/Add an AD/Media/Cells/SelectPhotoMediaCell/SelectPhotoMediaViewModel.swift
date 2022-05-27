//
//  SelectPhotoMediaViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 20/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct SelectPhotoMediaCellViewModel {
    enum ContentState {
        case loading
        case photo
    }

    let state: ContentState
    let media: UIImage?
    let count: String?
}
