//
//  LoadingView.swift
//  Whoppah
//
//  Created by Eddie Long on 02/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LoadingView: UIImageView {
    override var isHidden: Bool {
        didSet {
            if isHidden {
                stopAnimating()
            } else {
                startAnimating()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let images: [UIImage] = [#imageLiteral(resourceName: "loading_1"), #imageLiteral(resourceName: "loading_2"), #imageLiteral(resourceName: "loading_3"), #imageLiteral(resourceName: "loading_2")]
        animationImages = images
        animationDuration = 2
    }
}

extension Reactive where Base: LoadingView {
    /// Bindable sink for `hidden` property.
    var isLoading: Binder<Bool> {
        Binder(base) { view, loading in
            if loading {
                view.startAnimating()
            } else {
                view.stopAnimating()
            }
        }
    }
}
