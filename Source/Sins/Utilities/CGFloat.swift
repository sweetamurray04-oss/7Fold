//
//  Double.swift
//  Sins
//
//  Created by Luk on 2/4/26.
//

import Foundation
internal import CoreGraphics

extension CGFloat {
    func scale(_ double: Double) -> CGFloat {
        self * double
    }
    
    func getDirection(sprite: CGRect) -> Direction {
        self > sprite.midX ? Direction.forward : Direction.backward
    }
    
    func getDirection(midX: CGFloat) -> Direction {
        self > midX ? Direction.forward : Direction.backward
    }
    
    func getSpeed(direction: Direction, maxDistance: Double) -> Speed {
        direction == .forward ? self >= maxDistance ? .run : .walk : self <= maxDistance ? .run : .walk
    }
}
