//
//  PermissionsService.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/11/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import CoreLocation
import UIKit
import WhoppahCore
import FacebookCore
import AppTrackingTransparency

class PermissionsServiceImpl: NSObject, PermissionsService {
    // MARK: - Properties

    var isCameraAccessGranted: Bool { AVCaptureDevice.authorizationStatus(for: .video) == .authorized }
    var isLocationAccessGranted: Bool {
        CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var isTrackingPermissionGranted: Bool {
        ATTrackingManager.trackingAuthorizationStatus == .authorized
    }

    private var locationManager: CLLocationManager!

    // MARK: - Initialization

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func requestPermissionsIfApplicable() {
        if !isTrackingPermissionGranted &&
            ATTrackingManager.trackingAuthorizationStatus != .denied &&
            ATTrackingManager.trackingAuthorizationStatus != .restricted {
            requestTrackingPermission { authorized in
                if authorized {
                    Settings.shared.isAdvertiserIDCollectionEnabled = true
                    Settings.shared.isAdvertiserTrackingEnabled = true
                    Settings.shared.isAutoLogAppEventsEnabled = true
                }
            }
        } else if isTrackingPermissionGranted {
            Settings.shared.isAdvertiserIDCollectionEnabled = true
            Settings.shared.isAdvertiserTrackingEnabled = true
            Settings.shared.isAutoLogAppEventsEnabled = true
        }
    }

    // MARK: - Request Access

    func requestCameraAccess(completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            completionHandler(granted)
        })
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestTrackingPermission(completionHandler: @escaping (Bool) -> Void) {
        ATTrackingManager.requestTrackingAuthorization { authorizationStatus in
            completionHandler(authorizationStatus == .authorized)
        }
    }
}

extension PermissionsServiceImpl: CLLocationManagerDelegate {}
