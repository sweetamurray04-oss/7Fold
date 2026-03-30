//
//  Desk.swift
//  Sins
//
//  Created by user on 2/15/26.
//

import Foundation
import SpriteKit

struct Desk {
    let id = UUID()
    let imageName: String
    let type: UInt32
    var node: SKSpriteNode
    
    init(imageName: String,type: UInt32) {
        self.imageName = imageName
        self.type = type
        node = SKSpriteNode(imageNamed: imageName)
    }
}
