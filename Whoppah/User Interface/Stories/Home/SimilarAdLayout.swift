//
//  SimilarAdLayout.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import SquareMosaicLayout

final class SimilarAdLayout: SquareMosaicLayout, SquareMosaicDataSource {
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        dataSource = self
    }

    func layoutPattern(for _: Int) -> SquareMosaicPattern {
        SimilarAdLayoutPattern()
    }
}

class SimilarAdLayoutPattern: SquareMosaicPattern {
    func patternBlocks() -> [SquareMosaicBlock] {
        [SimilarAdLayoutBlock()]
    }
}

public class SimilarAdLayoutBlock: SquareMosaicBlock {
    public func blockFrames() -> Int {
        3
    }

    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let minWidth = (side - 40.0) / 3.0
        let maxWidth = (side - 40.0) - minWidth
        let minHeight = minWidth - 4.0
        let maxHeight = minHeight * 2 + 8.0
        var frames = [CGRect]()
        frames.append(CGRect(x: 16.0, y: origin, width: maxWidth, height: maxHeight))
        frames.append(CGRect(x: maxWidth + 8.0 + 16.0, y: origin, width: minWidth, height: minHeight))
        frames.append(CGRect(x: maxWidth + 8.0 + 16.0, y: origin + minHeight + 8.0, width: minWidth, height: minHeight))
        return frames
    }
}
