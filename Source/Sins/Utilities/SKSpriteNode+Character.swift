//
//  SKSpriteNode+Character.swift
//  Sins
//
//  Created by Luk on 2/4/26.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
//    func flip(_ direction: Direction) {
//        let value: CGFloat = direction == .forward ? 1.0 : -1.0
//        self.run(SKAction.scaleX(to: value, duration: 0.1))
//    }
    
    func animateMovement() {
        let walkTextures = [SKTexture(imageNamed: "walk1"),
                            SKTexture(imageNamed: "walk2"),
                            SKTexture(imageNamed: "walk3"),
                            SKTexture(imageNamed: "walk4"),
                            SKTexture(imageNamed: "walk5"),
                            SKTexture(imageNamed: "walk6"),
                            SKTexture(imageNamed: "walk7"),
                            SKTexture(imageNamed: "walk8"),
                            SKTexture(imageNamed: "walk9"),
                            SKTexture(imageNamed: "walk10")
                            
        ]
        let walkAnimation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        self.run(walkAnimation)
    }
    
//    func move(dt: CGFloat, direction: Direction, speed: Speed) {
//        let directionMultiplier: CGFloat = (direction == .forward) ? 1 : -1
//        let distance = directionMultiplier * speed.rawValue * dt
//        position.x += distance
//    }
    
    func stop() {
        let action = [SKTexture(imageNamed: "Pose01")]
        let idle = SKAction.animate(with: action, timePerFrame: 0.1)
        self.run(SKAction.sequence([idle]))
        self.removeAllActions()
    }
}
