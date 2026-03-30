//
//  CharacterActions.swift
//  Sins
//
//  Created by Luk on 1/28/26.
//

import Foundation
import SpriteKit

// Time duration
enum Speed: Double {
    case idle = 0
    case walk = 100
    case run = 400
}

enum Direction {
    case forward
    case backward
}

class CharacterState {
    var isMoving: Bool = false
    var walkDistance: Int = 0
    var isJumping: Bool = false
    var jumpDistance: Int = 0
    var joyStickMoved: Bool = false
    var speed: Speed = .idle
    var direction: Direction = .forward
    var isOnGround = true
    var isDead = false
}


class Level2 {
    var reachedFirstDoor = false
}

class Progress {
    var level2 = Level2()
}

class Sprite: SKSpriteNode {
    var timePerFrame = 0.08

    private let walkTextures = [
        SKTexture(imageNamed: "Run2_001"),
        SKTexture(imageNamed: "Run2_002"),
        SKTexture(imageNamed: "Run2_003"),
        SKTexture(imageNamed: "Run2_004"),
        SKTexture(imageNamed: "Run2_005"),
        SKTexture(imageNamed: "Run2_006"),
        SKTexture(imageNamed: "Run2_007"),
        SKTexture(imageNamed: "Run2_008"),
        SKTexture(imageNamed: "Run2_009"),
        SKTexture(imageNamed: "Run2_010")
    ]
    
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
    
    private let jumpTextures = [
        SKTexture(imageNamed: "jump1"),
        SKTexture(imageNamed: "jump2"),
        SKTexture(imageNamed: "jump3"),
        SKTexture(imageNamed: "jump4"),
        SKTexture(imageNamed: "jump5"),
        SKTexture(imageNamed: "jump6"),
        SKTexture(imageNamed: "jump7"),
        SKTexture(imageNamed: "jump8")
    ]
    
    private let dieTextures = [
        SKTexture(imageNamed: "DS_001"),
        SKTexture(imageNamed: "DS_002"),
        SKTexture(imageNamed: "DS_003"),
        SKTexture(imageNamed: "DS_004"),
        SKTexture(imageNamed: "DS_005"),
        SKTexture(imageNamed: "DS_006"),
        SKTexture(imageNamed: "DS_007"),
        SKTexture(imageNamed: "DS_008"),
        SKTexture(imageNamed: "DS_009"),
        SKTexture(imageNamed: "DS_010"),
        SKTexture(imageNamed: "DS_011"),
        SKTexture(imageNamed: "DS_012"),
        SKTexture(imageNamed: "DS_013"),
        SKTexture(imageNamed: "DS_014"),
        SKTexture(imageNamed: "DS_015")
    ]
    
    func die(actions: @escaping () -> Void) {
        SoundManager.shared.playSoundEffect(fileName: "scream")
        let die = SKAction.animate(with: dieTextures, timePerFrame: 0.15)
        run(die) {
            actions()
        }
    }
    
    func jump() {
        SoundManager.shared.playSoundEffect(fileName: "jumpingonwood")
        let jump = SKAction.animate(with: jumpTextures, timePerFrame: 0.10)
        run(jump, withKey: "jump")
    }
    
    func flip(_ direction: Direction) {
        let value: CGFloat = direction == .forward ? 1.0 : -1.0
        self.run(SKAction.scaleX(to: value, duration: 0.1))
    }
    
    func move(dt: CGFloat, direction: Direction, speed: Speed) {
        let directionMultiplier: CGFloat = (direction == .forward) ? 1 : -1
        let distance = directionMultiplier * speed.rawValue * dt
        position.x += distance
    }

    func startWalking() {
        SoundManager.shared.playSoundEffect(fileName: "footstep")
        removeAction(forKey: "idle")
        let walk = SKAction.animate(with: walkTextures, timePerFrame: timePerFrame)
        run(.repeatForever(walk), withKey: "walk")
    }

    func stopWalking() {
        SoundManager.shared.stopSoundEffect()
        removeAction(forKey: "walk")
        idle()
    }
    
    func idle() {
        let idle = SKAction.animate(with: idleTextures, timePerFrame: 0.35)
        run(.repeatForever(idle), withKey: "idle")
    }
}

class Character: SKSpriteNode {
    var state = CharacterState()
    var progress = Progress()
    var sprite = Sprite(imageNamed: "idle")
}
