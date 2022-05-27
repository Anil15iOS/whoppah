//
//  Deeplinkable.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import UIKit

protocol Deeplinkable {
    func openURLContexts(_ contexts: Set<UIOpenURLContext>)
}
