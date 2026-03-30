//
//  TeachersDesk.swift
//  Sins
//
//  Created by Luk on 2/16/26.
//

import Foundation
import SpriteKit

func TeachersDeskNode(size: CGSize) -> SKSpriteNode {
    let teachersDesk = SKSpriteNode(imageNamed: "TeachersDesk")
    teachersDesk.size = CGSize(width: size.width.scale(0.2), height: size.height.scale(0.5))
    teachersDesk.position = CGPoint(x: size.width.scale(0.1), y: size.height.scale(0.25))
    teachersDesk.zPosition = ZPositions.desk
    let deskField = CGSize(width: 12, height: 12)
    teachersDesk.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "TeachersDesk"), alphaThreshold: 0.8, size: CGSize(width: teachersDesk.size.width * 0.1, height: teachersDesk.size.height * 0.1))
    teachersDesk.physicsBody?.isDynamic = false // Static: does not move
    teachersDesk.physicsBody?.affectedByGravity = false
    teachersDesk.physicsBody?.categoryBitMask = CollideType.desk
    teachersDesk.physicsBody?.contactTestBitMask = CollideType.character
    teachersDesk.physicsBody?.collisionBitMask = CollideType.character
    return teachersDesk
}
