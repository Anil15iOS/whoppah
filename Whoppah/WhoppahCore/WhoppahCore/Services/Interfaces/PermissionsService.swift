//
//  PermissionsService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol PermissionsService {
    /// Whether camera access is granted
    var isCameraAccessGranted: Bool { get }

    /// Whether location access is granted
    var isLocationAccessGranted: Bool { get }
    
    func requestPermissionsIfApplicable()

    /// Requests camera permission
    ///
    /// - Parameter completion Called when the permission has been granted (or not)
    func requestCameraAccess(completionHandler: @escaping (Bool) -> Void)

    /// Requests location permission
    func requestLocationAccess()
}
