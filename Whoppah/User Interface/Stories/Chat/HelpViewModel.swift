//
//  HelpViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 04/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

enum HelpMode {
    case bullets
    case description
}

struct HelpConfig {
    let navTitle: String
    let title: String
    let mode: HelpMode
    let prefix: String
}

class HelpViewModel {
    private let coordinator: HelpCoordinator
    private let config: HelpConfig
    init(coordinator: HelpCoordinator, config: HelpConfig) {
        self.coordinator = coordinator
        self.config = config
    }
    
    var navTitle: String { config.navTitle }
    
    var title: String { config.title }

    struct Section {
        enum Mode {
            case bullets(texts: [String])
            case description(text: String)
        }
        let title: String
        let mode: Mode
    }

    var sections: [Section] {
        var sections = [Section]()
        var index = 1
        while let title = localizedString("\(config.prefix)-section-\(index)-title", logError: false) {
            switch config.mode {
            case .description:
                guard let description = localizedString("\(config.prefix)-section-\(index)-description", logError: false) else {
                    break
                }
                sections.append(Section(title: title, mode: .description(text: description)))
            case .bullets:
                var bullets = [String]()
                var bulletIndex = 1
                while let bullet = localizedString("\(config.prefix)-section-\(index)-bullet-\(bulletIndex)", logError: false) {
                    bullets.append(bullet)
                    bulletIndex += 1
                }
                sections.append(Section(title: title, mode: .bullets(texts: bullets)))
            }
            
            index += 1
        }
        return sections
    }
}
