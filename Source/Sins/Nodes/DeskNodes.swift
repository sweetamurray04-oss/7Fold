//
//  DeskNodes.swift
//  Sins
//
//  Created by Luk on 2/16/26.
//

import Foundation
import SpriteKit

func DeskNodes(size: CGSize) -> [Desk] {
//    let deskOrder: [Desk] = ["desk-normal": false, "desk-broken": true, "desk-broken-glow": true, "desk-glow": false]
    typealias cl = CollideType
    let deskOrder: [Desk] = [
        Desk(imageName: "desk-normal", type: cl.desk),
        Desk(imageName: "desk-broken", type: cl.brokenDesk),
        Desk(imageName: "desk-broken-glow", type: cl.brokenDesk),
        Desk(imageName: "desk-glow", type: cl.desk)
    ]
    
    var xAxis: CGFloat = 0.85
    var deskCount: Int {
        deskOrder.count
    }
    let evenAmount = CGFloat(xAxis/CGFloat(deskCount))
    xAxis = evenAmount
    
    var sortedDesks: [Desk] = []
    
    for desk in deskOrder {
        let node = desk.node
        node.size = CGSize(width: size.width.scale(0.15), height: size.height.scale(0.25))
        node.zPosition = ZPositions.desk
        node.position = CGPoint(x: size.width.scale(xAxis), y: size.height.scale(0.15))
        node.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: desk.imageName), size: CGSize(width: node.size.width * 0.1, height: node.size.height * 0.1))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask =
            desk.type == cl.brokenDesk ? cl.brokenDesk : cl.desk
        node.physicsBody?.collisionBitMask = cl.character
        node.physicsBody?.contactTestBitMask = cl.character

         if desk.type == cl.brokenDesk {
             node.name = desk.id.uuidString
         }

         xAxis += evenAmount
         sortedDesks.append(desk)
    }
    
    return sortedDesks
}
