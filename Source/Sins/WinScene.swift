//
//  WinScene.swift
//  Sins
//
//  Created by user on 2/17/26.
//

import UIKit
import SpriteKit
import GameplayKit

class WinScene: SKScene {
    var character: SKSpriteNode!
    
    private let idleTextures = [
            SKTexture(imageNamed: "Idle1_001"),
            SKTexture(imageNamed: "Idle1_002"),
            SKTexture(imageNamed: "Idle1_003"),
            SKTexture(imageNamed: "Idle1_004"),
            SKTexture(imageNamed: "Idle1_005"),
            SKTexture(imageNamed: "Idle1_006"),
            SKTexture(imageNamed: "Idle1_007"),
            SKTexture(imageNamed: "Idle1_008")
        ]
    func idle() {
            let idle = SKAction.animate(with: idleTextures, timePerFrame: 0.25)
        character.run(.repeatForever(idle), withKey: "idle")
        }
    
    override func sceneDidLoad() {
        backgroundColor = .black
        
        let scaleFactor = 0.5
        character = SKSpriteNode(imageNamed: "idle")
        character.position = CGPoint(x: size.width.scale(0.5) , y: size.height.scale(0.5))
        character.size = CGSize(width: size.width.scale(scaleFactor), height: size.height.scale(scaleFactor))
        
        addChild(character)
        idle()
    }
    
}
