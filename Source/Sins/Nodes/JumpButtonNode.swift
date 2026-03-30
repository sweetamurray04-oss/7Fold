//
//  JumpButtonNode.swift
//  Sins
//
//  Created by Luk on 2/5/26.
//

import Foundation
import UIKit
import SpriteKit

func JumpButtonNode(size: CGSize, device: Device) -> JumpButton {
    let circle = Circle()
    let scale = device == .phone ? 0.35 : 0.5
    circle.xScale = scale
    circle.yScale = scale
    circle.zPosition = ZPositions.outerCircle
    circle.alpha = 0.7
    // Opposite direction
    circle.position = CGPoint(x: size.width.scale(0.90), y: size.height.scale(0.10))
    return JumpButton(node: circle, isJumping: false)
}
