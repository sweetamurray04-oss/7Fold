//
//  SKSpriteNode+SKPhysics.swift
//  Sins
//
//  Created by Luk on 2/9/26.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func addGround(size: CGSize?) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size == nil ? self.size : size!)
        self.physicsBody?.isDynamic = false // Static: does not move
        self.physicsBody?.affectedByGravity = false
    }
}
