//
//  HomeLooksLayout.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import SquareMosaicLayout

final class LooksLayout: SquareMosaicLayout, SquareMosaicDataSource {
    private var isLeft = true

    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        dataSource = self
    }

    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        switch collectionView?.numberOfItems(inSection: section) {
        case 3:
            var pattern: SquareMosaicPattern!
            if isLeft {
                pattern = MosaicLeft()
            } else {
                pattern = MosaicRight()
            }
            isLeft = !isLeft
            return pattern
        case 1:
            return LargeSingle()
        default: break
        }

        return LargeSingle()
    }

    func layoutSeparatorBetweenSections() -> CGFloat {
        32
    }
}

class MosaicLeft: SquareMosaicPattern {
    func patternBlocks() -> [SquareMosaicBlock] {
        [LooksLayoutLeftMosaic()]
    }
}

class LargeSingle: SquareMosaicPattern {
    func patternBlocks() -> [SquareMosaicBlock] {
        [HomeLooksLayoutLargeBlock()]
    }
}

class MosaicRight: SquareMosaicPattern {
    func patternBlocks() -> [SquareMosaicBlock] {
        [LooksLayoutRightMosaic()]
    }
}

public class LooksLayoutLeftMosaic: SquareMosaicBlock {
    public func blockFrames() -> Int {
        3
    }

    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let paddingLR: CGFloat = 16.0
        let interItemSpacing: CGFloat = 8.0

        let minWidth = (side - paddingLR * 2 - interItemSpacing) / 3.0
        let maxWidth = side - paddingLR * 2
        let minHeight = minWidth - 4.0
        var frames = [CGRect]()
        let topLeft = CGRect(x: paddingLR, y: origin, width: minWidth * 2, height: minHeight)
        frames.append(topLeft)
        let topRight = CGRect(x: topLeft.maxX + interItemSpacing, y: origin, width: minWidth, height: minHeight)
        frames.append(topRight)
        frames.append(CGRect(x: paddingLR, y: origin + minHeight + interItemSpacing, width: maxWidth, height: minHeight))
        return frames
    }
}

public class LooksLayoutRightMosaic: SquareMosaicBlock {
    public func blockFrames() -> Int {
        3
    }

    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let paddingLR: CGFloat = 16.0
        let interItemSpacing: CGFloat = 8.0

        let minWidth = (side - paddingLR * 2 - interItemSpacing) / 3.0
        let maxWidth = side - paddingLR * 2
        let minHeight = minWidth - 4.0
        var frames = [CGRect]()
        let topLeft = CGRect(x: paddingLR, y: origin, width: minWidth, height: minHeight)
        frames.append(topLeft)
        let topRight = CGRect(x: topLeft.maxX + interItemSpacing, y: origin, width: minWidth * 2, height: minHeight)
        frames.append(topRight)
        frames.append(CGRect(x: paddingLR, y: origin + minHeight + interItemSpacing, width: maxWidth, height: minHeight))
        return frames
    }
}

public class HomeLooksLayoutLargeBlock: SquareMosaicBlock {
    public func blockFrames() -> Int {
        1
    }

    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: side, height: side * LookCell.aspect))
        return frames
    }
}
