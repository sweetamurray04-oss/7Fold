//
//  JoyStick.swift
//  Sins
//
//  Created by Luk on 2/4/26.
//

import Foundation
import SpriteKit

func JoyStickNode(size: CGSize, device: Device) -> JoyStick {
    var scale = device == .phone ? 0.20 : 0.25
    
    let radius: CGFloat = 100.0
    
    let circle = SKShapeNode(circleOfRadius: radius)
    
    let thumbstick = circle
    
    // MARK: Placeholder is circle will change properties later
    
    thumbstick.position = CGPoint(x: size.width.scale(0.10), y: size.height.scale(0.10))
    thumbstick.xScale = scale
    thumbstick.yScale = scale
    thumbstick.zPosition = ZPositions.thumbstick
    
    thumbstick.fillColor = SKColor.white
    
    thumbstick.isAntialiased = true
    thumbstick.alpha = 0.6
    
    let outerFrame = Circle()
    
    scale = device == .phone ? 0.35 : 0.5
    
    outerFrame.xScale = scale
    outerFrame.yScale = scale
    outerFrame.zPosition = ZPositions.outerCircle
    
    outerFrame.position = CGPoint(x: thumbstick.frame.midX, y: thumbstick.frame.midY)
    return JoyStick(thumbstick: thumbstick, outerFrame: outerFrame)
}

