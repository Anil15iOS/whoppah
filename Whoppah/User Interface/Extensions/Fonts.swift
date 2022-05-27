//
//  UIFont+Whoppah.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

extension UIFont {
    class var h1: UIFont {
        .boldSystemFont(ofSize: 22.0)
    }

    class var h2: UIFont {
        UIFont(name: "SFProText-SemiBold", size: 20.0)!
    }

    class var h3: UIFont {
        UIFont(name: "GalanoGrotesque-SemiBold", size: 18.0)!
    }

    class var button: UIFont {
        UIFont(name: "GalanoGrotesque-SemiBold", size: 14.0)!
    }

    class var primaryButton: UIFont {
        UIFont(name: "GalanoGrotesque-SemiBold", size: 16.0)!
    }

    class var subtitle: UIFont {
        UIFont(name: "GalanoGrotesque-SemiBold", size: 12.0)!
    }

    class var descriptionLabel: UIFont {
        UIFont(name: "SFProText-Regular", size: 17.0)!
    }

    class var label: UIFont {
        UIFont(name: "SFProText-Regular", size: 15.0)!
    }

    class var bodyText: UIFont {
        UIFont(name: "SFProText-Regular", size: 14.0)!
    }

    class var bodySmall: UIFont {
        UIFont(name: "SFProText-Regular", size: 13.0)!
    }

    class var bodySemibold: UIFont {
        UIFont(name: "SFProText-SemiBold", size: 13.0)!
    }

    class var descriptionText: UIFont {
        UIFont(name: "SFProText-Regular", size: 11.0)!
    }

    class var descriptionSemibold: UIFont {
        UIFont(name: "SFProText-SemiBold", size: 11.0)!
    }

    class var smallText: UIFont {
        UIFont(name: "SFProText-Regular", size: 12.0)!
    }
}
