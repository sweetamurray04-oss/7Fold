//
//  SKPhysicsContact+Collision.swift
//  Sins
//
//  Created by Luk on 2/12/26.
//

import Foundation
import SpriteKit

extension SKPhysicsContact {
    func compareCollision(bodyA: UInt32, bodyB: UInt32) -> Bool {
        if (self.bodyA.categoryBitMask == bodyA && self.bodyB.categoryBitMask == bodyB) || (self.bodyB.categoryBitMask == bodyA && self.bodyA.categoryBitMask == bodyB) {
            return true
        }
        return false
    }
}
