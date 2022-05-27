//
//  WPBubble.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/29/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

private func deg2rad(_ number: Double) -> Double {
    number * .pi / 180
}

class WPBubbleTextView: UITextView {
    // MARK: - Overrided

    public override var canBecomeFirstResponder: Bool {
        false
    }

    // MARK: - Initialization

    init() {
        super.init(frame: .zero, textContainer: nil)
        setupView()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private var image: UIImage?

    // MARK: - Setup

    open func setupView() {
        isEditable = false
        isSelectable = true
        isScrollEnabled = false
        dataDetectorTypes = [.flightNumber, .calendarEvent, .address, .phoneNumber, .link, .lookupSuggestion]
        isUserInteractionEnabled = true
        delaysContentTouches = true
        font = UIFont.preferredFont(forTextStyle: .body)
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        backgroundColor = .clear
    }

    func calculatedSize(in size: CGSize) -> CGSize {
        sizeThatFits(CGSize(width: size.width, height: .infinity))
    }

    // Disables text selection
    public override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }

        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: UITextDirection(rawValue: UITextLayoutDirection.left.rawValue)) else { return false }

        let startIndex = offset(from: beginningOfDocument, to: range.start)

        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }
}

class WPBubble: UIView {
    var textview: WPBubbleTextView!
    private var leftImageView: UIImageView?
    private var rightText: UILabel?
    private var leftTextConstraint: NSLayoutConstraint?
    private var rightTextConstraint: NSLayoutConstraint?

    private let leftImageMargin: CGFloat = 4
    private let rightTextLeftMargin: CGFloat = 8
    private let rightTextLeftPadding: CGFloat = 8
    private let rightTextRightPadding: CGFloat = 32
    private let textDefaultMargin: CGFloat = UIConstants.margin
    private let textTopMargin: CGFloat = 5
    private let textBottomMargin: CGFloat = 11

    enum Direction {
        case left
        case right
    }

    var direction: Direction = .left

    var color: UIColor = .smoke {
        didSet {
            setNeedsDisplay()
        }
    }

    var leftImage: UIImage? {
        get {
            leftImageView?.image
        }
        set {
            setupImage(newValue)
        }
    }

    struct RightSection {
        let backgroundColor: UIColor
        let textColor: UIColor?
        let text: String
    }

    var rightSection: RightSection? {
        didSet {
            setupRightSection(rightSection)
        }
    }

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Setup

    open func setupView() {
        backgroundColor = .clear
        textview = WPBubbleTextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(textview)
        textview.verticalPin(to: self, orientation: .top, padding: textTopMargin)
        textview.verticalPin(to: self, orientation: .bottom, padding: -textBottomMargin)
        leftTextConstraint = textview.horizontalPin(to: self, orientation: .leading, padding: textDefaultMargin)
        rightTextConstraint = textview.horizontalPin(to: self, orientation: .trailing, padding: -textDefaultMargin)
    }

    private func setupImage(_ image: UIImage?) {
        defer {
            layoutIfNeeded()
        }
        guard image != nil else {
            if let existingLeft = leftTextConstraint {
                removeConstraint(existingLeft)
            }
            leftTextConstraint = textview.horizontalPin(to: self, orientation: .leading, padding: textDefaultMargin)
            leftImageView?.removeFromSuperview()
            leftImageView = nil
            return
        }
        if let imageview = leftImageView {
            imageview.image = image
        } else {
            let imageview = ViewFactory.createImage(image: image)
            addSubview(imageview)
            imageview.horizontalPin(to: self, orientation: .leading, padding: UIConstants.margin)
            imageview.contentMode = .scaleAspectFill
            if let existingLeft = leftTextConstraint {
                removeConstraint(existingLeft)
            }
            imageview.setContentHuggingPriority(.required, for: .horizontal)
            imageview.setContentCompressionResistancePriority(.required, for: .horizontal)
            leftTextConstraint = textview.alignAfter(view: imageview, withPadding: leftImageMargin, safeArea: false)
            imageview.center(withView: textview, orientation: .vertical, padding: 2)
            leftImageView = imageview
        }
    }

    private func setupRightSection(_ section: RightSection?) {
        defer {
            layoutIfNeeded()
            setNeedsDisplay()
        }
        guard let section = section else {
            if let existingRight = rightTextConstraint {
                removeConstraint(existingRight)
            }
            rightTextConstraint = textview.horizontalPin(to: self, orientation: .trailing, padding: textDefaultMargin)
            rightText?.removeFromSuperview()
            rightText = nil
            return
        }
        if rightText == nil {
            let label = ViewFactory.createLabel(text: section.text)
            addSubview(label)
            label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            label.textAlignment = .center
            if let existingRight = rightTextConstraint {
                removeConstraint(existingRight)
            }
            rightTextConstraint = textview.alignBefore(view: label, withPadding: -rightTextLeftMargin, safeArea: false)
            label.horizontalPin(to: self, orientation: .trailing)
            label.pinToEdges(of: self, orientation: .vertical)
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            rightText = label
        }
        rightText?.text = section.text
        rightText?.backgroundColor = section.backgroundColor
        rightText?.textColor = section.textColor
    }

    func calculatedSize(in size: CGSize) -> CGSize {
        var outWidth: CGFloat = 0
        var outHeight: CGFloat = 0
        if let leftImage = leftImageView, let image = leftImage.image {
            outWidth = UIConstants.margin + image.size.width + leftImageMargin
            outHeight = leftImage.bounds.size.height
        }
        if let right = rightText, let text = right.text {
            let width: CGFloat = text.width(withConstrainedHeight: min(outHeight, 40), font: right.font)
            outWidth += (rightTextLeftMargin + rightTextLeftPadding + width + rightTextRightPadding)
        }

        if rightText == nil, leftImageView == nil {
            // default margins for text in the cell
            outWidth += (2 * textDefaultMargin)
        }
        let textSize = textview.calculatedSize(in: CGSize(width: size.width - outWidth, height: size.height))
        outWidth += textSize.width
        outHeight = max(textSize.height + textTopMargin + textBottomMargin, outHeight)

        return CGSize(width: outWidth, height: outHeight)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Size of rounded rectangle
        let rectWidth = rect.width
        let rectHeight = rect.height

        // Find center of actual frame to set rectangle in middle
        let xf: CGFloat = (frame.width - rectWidth) / 2
        let yf: CGFloat = (frame.height - rectHeight) / 2

        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        let radius: CGFloat = min(40, rect.height / 2)
        let rect = CGRect(x: xf, y: yf, width: rectWidth, height: rectHeight)

        let singleLine = rect.height <= 45
        if singleLine {
            let path = UIBezierPath()
            let leftInsetTop: CGFloat = 24
            let leftInsetBottom: CGFloat = 8

            switch direction {
            case .left:
                /*
                 Draws shape like this
                      ------------
                                 |
                                 |
                   --------------
                 */
                path.move(to: CGPoint(x: rect.minX + leftInsetTop, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX + leftInsetBottom, y: rect.maxY))
                let begin = CGPoint(x: rect.minX + leftInsetBottom, y: rect.maxY)

                // Draw the bezier curve arc on the left hand side
                path.move(to: begin)
                let controlPoint1 = CGPoint(x: rect.minX - 8, y: rect.maxY - 2)
                let controlPoint2 = CGPoint(x: rect.minX + 4, y: rect.minY + 1)
                path.addCurve(to: CGPoint(x: rect.minX + leftInsetTop, y: rect.minY), controlPoint1: controlPoint1, controlPoint2: controlPoint2)

                // Draw rounded rect on the right hand side
                let endCenterCircle = CGPoint(x: rect.maxX - radius, y: rect.midY)
                path.move(to: endCenterCircle)
                path.addArc(withCenter: endCenterCircle, radius: radius, startAngle: CGFloat(deg2rad(270)), endAngle: CGFloat(deg2rad(90)), clockwise: true)
            case .right:
                /*
                 Draws shape like this
                   -----------
                   |
                   |
                   --------------
                 */
                path.move(to: CGPoint(x: rect.maxX - leftInsetTop, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX - leftInsetBottom, y: rect.maxY))

                // Draw the bezier curve arc on the right hand side
                let begin = CGPoint(x: rect.maxX - leftInsetBottom, y: rect.maxY)
                path.move(to: begin)
                let controlPoint1 = CGPoint(x: rect.maxX + 8, y: rect.maxY - 2)
                let controlPoint2 = CGPoint(x: rect.maxX - 4, y: rect.minY + 1)
                path.addCurve(to: CGPoint(x: rect.maxX - leftInsetTop, y: rect.minY), controlPoint1: controlPoint1, controlPoint2: controlPoint2)

                // Draw rounded rect on the left hand side
                let endCenterCircle = CGPoint(x: rect.minX + radius, y: rect.midY)
                path.move(to: endCenterCircle)
                path.addArc(withCenter: endCenterCircle, radius: radius, startAngle: CGFloat(deg2rad(90)), endAngle: CGFloat(deg2rad(270)), clockwise: true)
            }

            path.close()
            ctx.addPath(path.cgPath)

            // Need to mask the right hand size (if present)
            // Otherwise it won't fill nicely
            if let right = rightText {
                let mask = CAShapeLayer()
                mask.position = CGPoint(x: -right.frame.minX, y: 0)
                mask.path = path.cgPath
                right.layer.mask = mask
            }

        } else {
            let regular = UIBezierPath(roundedRect: rect, cornerRadius: 18)
            ctx.addPath(regular.cgPath)

            // Need to mask the right hand size (if present)
            // Otherwise it won't fill nicely
            if let right = rightText {
                let mask = CAShapeLayer()
                mask.position = CGPoint(x: -right.frame.minX, y: 0)
                mask.path = regular.cgPath
                right.layer.mask = mask
            }
        }
        ctx.setFillColor(color.cgColor)

        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
    }
}
