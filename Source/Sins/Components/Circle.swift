//
//  Circle.swift
//  Sins
//
//  Created by Luk on 2/4/26.
//

import Foundation
import SpriteKit

func Circle() -> SKShapeNode {
    let radius: CGFloat = 100.0
    let circle = SKShapeNode(circleOfRadius: radius)
    circle.strokeColor = .gray
    circle.lineWidth = 10.0
    circle.fillColor = .white
    circle.alpha = 0.4
    return circle
}
