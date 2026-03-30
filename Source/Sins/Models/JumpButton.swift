//
//  JumpButton.swift
//  Sins
//
//  Created by Luk on 2/5/26.
//

import Foundation
import SpriteKit

class JumpButton {
    let node: SKShapeNode
    var isJumping: Bool = false
    var touch: UITouch?
    
    init(node: SKShapeNode, isJumping: Bool) {
        self.node = node
        self.isJumping = isJumping
    }
    
    func disable() {
        node.isUserInteractionEnabled = false
    }
}
