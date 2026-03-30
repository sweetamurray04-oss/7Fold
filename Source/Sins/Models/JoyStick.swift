//
//  JoyStick.swift
//  Sins
//
//  Created by Luk on 2/4/26.
//

import Foundation
import SpriteKit

class JoyStick {
    let thumbstick: SKShapeNode
    let outerFrame: SKShapeNode
    let midX: CGFloat
    var isMoving = false
    // Empty initialization until needed for touchesMoved
    var touchLocation: CGPoint
    var touch: UITouch?

    var maxDistance: Double {
        switch direction {
        case .forward:
            return outerFrame.frame.maxX
        case .backward:
            return outerFrame.frame.minX
        }
    }
    
    var direction: Direction {
        touchLocation.x.getDirection(midX: midX)
    }
    
    var speed: Speed = .idle
    
    init(thumbstick: SKShapeNode, outerFrame: SKShapeNode, midX: CGFloat = 0, touchLocation: CGPoint = CGPoint(x: 0, y: 0)) {
        self.thumbstick = thumbstick
        self.outerFrame = outerFrame
        self.midX = thumbstick.frame.midX
        self.touchLocation = touchLocation
    }
    
    func disable() {
        thumbstick.isUserInteractionEnabled = false
    }
    
    func move() {
        let x = floor(touchLocation.x)
        let roundedMaxDistance = floor(maxDistance)
        let equation = direction == .forward ? x >= roundedMaxDistance : x <= roundedMaxDistance
        if equation {
            thumbstick.position = CGPoint(x: maxDistance, y: thumbstick.frame.midY)
            speed = .run
        } else {
            thumbstick.position = CGPoint(x: touchLocation.x, y: thumbstick.frame.midY)
            speed = .walk
        }
    }
    
    func stop() {
        thumbstick.position = CGPoint(x: midX, y: thumbstick.frame.midY)
        speed = .idle
        isMoving = false
    }
}
