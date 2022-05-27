//
//  Carousel.swift
//  Whoppah
//
//  Created by Eddie Long on 24/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class Carousel: UIScrollView {
    var pageSizePadding: CGFloat = 96
    var leftRightPadding: CGFloat = 32
    var pageGap: CGFloat = 24
    var scrolling = PublishSubject<Bool>()
    var carouselItems = [UIView]()

    private var selectedView: UIView? {
        didSet {
            let oldIndex = oldValue != nil ? (getIndex(forView: oldValue!) ?? 0) : 0
            if let v = selectedView, let index = getIndex(forView: v) {
                let direction = oldIndex > index ? Direction.left : Direction.right
                onPageChange?(direction, index)
            }
        }
    }

    override var bounds: CGRect {
        didSet {
            recalculateDimensions()
        }
    }

    enum Direction: String {
        case left
        case right
    }

    // When a page is changed
    var onPageChange: ((Direction, Int) -> Void)?
    // When a page that is already the current page is tapped
    var onPageTapped: ((Int) -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common

    private func commonInit() {
        delegate = self
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        recalculateDimensions()
    }

    func addCarouselItem(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        carouselItems.append(view)
        addSubview(view)
    }

    func layout() {
        recalculateDimensions()
    }

    private func recalculateDimensions() {
        frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let pageSize = bounds.width - pageSizePadding
        let numPages = CGFloat(subviews.count)
        var startX: CGFloat = leftRightPadding
        // Add pageGap at either side
        let contentWidth = pageSize * numPages + (numPages - 1) * pageGap + 2 + leftRightPadding * 2
        contentSize = CGSize(width: contentWidth, height: bounds.height)
        for view in carouselItems {
            view.frame = CGRect(x: startX, y: 0, width: pageSize, height: bounds.height)
            view.bounds = CGRect(x: 0, y: 0, width: pageSize, height: bounds.height)
            startX += (pageGap + pageSize)
        }

        var hasTrailing = false
        for constraint in constraints {
            switch constraint.firstAttribute.rawValue {
            case NSLayoutConstraint.Attribute.leading.rawValue:
                if (constraint.firstItem as? UIView) != carouselItems.first {
                    constraint.isActive = false
                } else {
                    constraint.isActive = true
                }
            case NSLayoutConstraint.Attribute.trailing.rawValue:
                if (constraint.firstItem as? UIView) != carouselItems.last {
                    constraint.isActive = false
                } else {
                    constraint.isActive = true
                    hasTrailing = true
                }
            default: break
            }
        }

        if !hasTrailing, let last = carouselItems.filter({ $0.isVisible }).last {
            trailingAnchor.constraint(equalTo: last.trailingAnchor,
                                      constant: 0).isActive = true
        }
    }

    func scrollTo(view: UIView, animated: Bool = true) {
        for subview in subviews where view == subview {
            selectedView = view
            setContentOffset(CGPoint(x: view.frame.midX - bounds.size.width / 2, y: contentOffset.y), animated: animated)
        }
    }

    func scrollTo(index: Int, animated _: Bool = true) {
        guard index < subviews.count else { return }
        scrollTo(view: subviews[index])
    }

    @objc func itemTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        // Is this page already the selected page?
        if selectedView == view, let index = getIndex(forView: selectedView!) {
            onPageTapped?(index)
        } else {
            scrollTo(view: view)
        }
    }

    func getIndex(forView view: UIView) -> Int? {
        subviews.firstIndex(of: view)
    }
}

extension Carousel: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrolling.onNext(false)
        guard !decelerate else {
            return
        }

        setContentOffset(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        scrolling.onNext(false)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setContentOffset(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !scrollView.isDecelerating else {
            scrolling.onNext(false)
            return
        }
        scrolling.onNext(true)
    }

    func scrollViewWillBeginDragging(_: UIScrollView) {
        scrolling.onNext(true)
    }

    func setContentOffset(_ scrollView: UIScrollView) {
        let midPoint = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.size.width / 2, y: scrollView.contentOffset.y)

        var views: [UIView]!
        if let first = subviews.first, scrollView.contentOffset.x < first.frame.minX {
            views = [first]
        } else if let last = subviews.last, scrollView.contentOffset.x > last.frame.minX {
            views = [last]
        } else {
            views = scrollView.subviews.filter {
                // Check other views first
                if selectedView != $0 {
                    // Give a nice amount of overlap
                    let rectWithPadding = $0.frame.insetBy(dx: -pageGap / 2 - $0.bounds.width / 2, dy: 0)
                    return rectWithPadding.contains(midPoint)
                }
                return false
            }
        }

        if let matchedView = views.first {
            scrollTo(view: matchedView)
        } else if let view = selectedView {
            scrollTo(view: view)
        }
    }
}
