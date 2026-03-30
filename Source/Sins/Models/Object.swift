//
//  Object.swift
//  Sins
//
//  Created by Luk on 2/9/26.
//

import Foundation
import SpriteKit

struct Object {
    var node: SKSpriteNode
    var type: InteractionType
    
    init(node: SKSpriteNode, type: InteractionType) {
        self.node = node
        self.type = type        
    }
}
