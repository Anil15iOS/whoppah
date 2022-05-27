//
//  ExpandableSection.swift
//  Whoppah
//
//  Created by Eddie Long on 24/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class ExpandableSection: UIView {
    var title: String = ""
    var isOpen: Bool = false {
        willSet {
            if newValue != isOpen {
                toggleExpand(newValue)
            }
        }
    }

    typealias ExpandCompletion = (Bool) -> Void 
    var onExpandToggle: ExpandCompletion?
    
    var contentView: UIStackView!
    private var titleLabel: UILabel!
    private var arrowIcon: UIImageView!

    private let bag = DisposeBag()

    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        commonInit()
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
        let tappableView = ViewFactory.createView()
        tappableView.backgroundColor = UIColor(hexString: "#F3F4F6")
        addSubview(tappableView)
        tappableView.pinToEdges(of: self, orientation: .horizontal)
        tappableView.verticalPin(to: self, orientation: .top)
        titleLabel = ViewFactory.createLabel(text: title, font: .descriptionLabel)
        tappableView.addSubview(titleLabel)
        titleLabel.verticalPin(to: tappableView, orientation: .top, padding: 10)
        titleLabel.horizontalPin(to: tappableView, orientation: .leading, padding: UIConstants.margin)
        tappableView.verticalPin(to: titleLabel, orientation: .bottom, padding: 10)
        arrowIcon = ViewFactory.createImage(image: R.image.ic_down_arrow_black())
        tappableView.addSubview(arrowIcon)
        arrowIcon.center(withView: titleLabel, orientation: .vertical)
        arrowIcon.horizontalPin(to: tappableView, orientation: .trailing, padding: -UIConstants.margin)
        arrowIcon.setWidthAnchor(12)
        titleLabel.alignBefore(view: arrowIcon, withPadding: -8)

        let dividerTop = ViewFactory.createDivider(orientation: .horizontal)
        tappableView.addSubview(dividerTop)
        dividerTop.pinToEdges(of: tappableView, orientation: .horizontal)
        dividerTop.verticalPin(to: tappableView, orientation: .top)

        contentView = ViewFactory.createVerticalStack()
        addSubview(contentView)
        contentView.pinToEdges(of: self, orientation: .horizontal)
        contentView.alignBelow(view: tappableView, withPadding: 0)
        verticalPin(to: contentView, orientation: .bottom)

        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isOpen = !self.isOpen
            self.onExpandToggle?(self.isOpen)
        }).disposed(by: bag)
        tappableView.addGestureRecognizer(tap)
    }

    func toggleExpand(_ newValue: Bool, animate: Bool = true) {
        if animate {
            for subview in contentView.arrangedSubviews {
                if !newValue {
                    UIView.animate(
                        withDuration: 0.3,
                        delay: 0.0,
                        options: [.curveEaseOut],
                        animations: {
                            subview.isHidden = true
                            subview.alpha = 0.0
                        }, completion: { _ in
                            self.arrowIcon.image = R.image.ic_down_arrow_black()
                            self.isOpen = newValue
                        }
                    )
                } else {
                    subview.isHidden = false
                    UIView.animate(
                        withDuration: 0.2,
                        delay: 0.0,
                        options: [.curveEaseOut],
                        animations: {
                            subview.alpha = 1.0
                        }, completion: { _ in
                            self.arrowIcon.image = R.image.ic_up_arrow_black()
                            self.isOpen = newValue
                        }
                    )
                }
            }
        } else {
            for subview in contentView.arrangedSubviews {
                if !newValue {
                    subview.isHidden = true
                    subview.alpha = 0.0
                    arrowIcon.image = R.image.ic_down_arrow_black()
                } else {
                    subview.isHidden = false
                    subview.alpha = 1.0
                    arrowIcon.image = R.image.ic_up_arrow_black()
                }
            }
            isOpen = newValue
        }
    }
}
