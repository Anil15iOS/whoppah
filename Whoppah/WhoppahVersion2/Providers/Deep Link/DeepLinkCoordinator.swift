//
//  DeepLinkProvider.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import Combine
import WhoppahUI

struct DeepLinkCoordinator {
    private var deeplinkSubject: CurrentValueSubject<NavigatableView?, Error>
    public var deeplinkPublisher: AnyPublisher<NavigatableView?, Error>
    
    init() {
        deeplinkSubject = CurrentValueSubject<NavigatableView?, Error>(nil)
        deeplinkPublisher = deeplinkSubject.eraseToAnyPublisher()
    }

    func parse(_ url: URL) {
//        let lastPathComponent = url.lastPathComponent.lowercased()
//        guard let deeplink = DeepLink(rawValue: lastPathComponent) else { return }
//        deeplinkSubject.send(deeplink)
    }
    
    func handle(_ deepLink: NavigatableView) {
        deeplinkSubject.send(deepLink)
    }
    
    func reset() {
        deeplinkSubject.send(nil)
    }
}
