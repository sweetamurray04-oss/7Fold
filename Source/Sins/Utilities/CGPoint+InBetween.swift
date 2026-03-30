//
//  CGPoint+InBetween.swift
//  Sins
//
//  Created by Luk on 2/4/26.
//

import Foundation
internal import CoreGraphics

extension CGPoint {
    func inBetween(_ coordinates: CGRect) -> Bool {
        let x = CGFloat(self.x)
        let y = CGFloat(self.y)
        if x >= coordinates.minX && x <= coordinates.maxX && y >= coordinates.minY && y <= coordinates.maxY {
            return true
        }
        return false
    }
}
