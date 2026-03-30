//
//  GameScene.swift
//  Sins
//
//  Created by Luk on 1/27/26.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct CollideType {
    static let character: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let desk: UInt32 = 0x1 << 3
    static let brokenDesk: UInt32 = 0x1 << 4
    static let door: UInt32 = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gameState: GameState
    let device: Device
    var character = Character()
    var joyStick: JoyStick
    var jumpButton: JumpButton
    var outerCircleCoords: CGRect!
    var idleX: CGFloat = 0
    var outOfBounds: Double {
        let direction = character.state.direction
        
        switch direction {
        case .forward:
            return size.width.scale(0.90)
        case .backward:
            return size.width.scale(0.10)
        }
    }
    var currentSpeed: Speed = .idle
    
    init(size: CGSize, device: Device, gameState: GameState) {
        self.device = device
        self.gameState = gameState
        self.joyStick = JoyStickNode(size: size, device: device)
        self.jumpButton = JumpButtonNode(size: size, device: device)
        super.init(size: size)
    }
    
    var lastUpdateTime: TimeInterval = 0
    var dt: Double = 0
    let moveSpeed: CGFloat = 300
    var deltaTime: CGFloat = 0
    var timesJumped = 0
    var groundLevel: CGFloat = 0
    var minimumLevel: CGFloat = 0
    var groundContacts = 0
    var deskContacts = 0
    var brokenDeskContacts = 0
    var firstStageCompleted = false
    var dead = false
    var desks: [Desk]!
    var brokenDeskIDs = Set<String>()
    var door: SKSpriteNode!
    var hands: [SKSpriteNode] = []
    var backgroundDesks: [SKSpriteNode] = []
    
    fileprivate func makeScene() -> GameScene {
        let scene = GameScene(size: size, device: device, gameState: gameState)
        scene.scaleMode = scaleMode
        return scene
    }

    func reloadScene() {
        view?.presentScene(makeScene(), transition: .crossFade(withDuration: 1))
    }
    
    func getBrokenDesk(contact: SKPhysicsContact) -> Desk {
        let desks = desks.filter { $0.type == cl.brokenDesk }
        var foundDesk: Desk!
        desks.forEach {
            if contact.bodyA.node?.name == $0.id.uuidString || contact.bodyB.node?.name == $0.id.uuidString {
                foundDesk = $0
            }
        }
        return foundDesk
    }
    
    func breakDesk(desk: Desk) {
        let node = desk.node
        let breakingTextures = [
            SKTexture(imageNamed: "Desk_Breaking_Animation-1"),
            SKTexture(imageNamed: "Desk_Breaking_Animation-2"),
            SKTexture(imageNamed: "Desk_Breaking_Animation-3"),
            SKTexture(imageNamed: "Desk_Breaking_Animation-4"),
            SKTexture(imageNamed: "Desk_Breaking_Animation-5"),
            SKTexture(imageNamed: "Desk_Breaking_Animation-6"),
            SKTexture(imageNamed: "Desk_Breaking_Animation-7")
        ]
        
        let destroy = SKAction.animate(with: breakingTextures, timePerFrame: 0.15)
        node.texture = SKTexture(imageNamed: "Desk_Breaking_Animation-1")
        
        run(SKAction.wait(forDuration: 0.5)) {
            node.run(destroy) {
                node.physicsBody = nil
            }
        }
    }
    
    var isGrounded: Bool {
        return groundContacts > 0
    }
    var onDesk: Bool {
        return deskContacts > 0
    }
    var onBrokenDesk: Bool {
        return brokenDeskContacts > 0
    }
    
    var teachersDesk: SKSpriteNode!
    var contactManager = SKPhysicsContact()
    typealias cl = CollideType
    
    func didBegin(_ contact: SKPhysicsContact) {

        let isGroundContact = contact.compareCollision(bodyA: cl.character, bodyB: cl.ground)

        if isGroundContact && character.sprite.position.x > size.width.scale(0.15) {
            dead = true
            character.stop()
            character.sprite.idle()
            self.character.sprite.die {
                self.reloadScene()
            }
        }
        
        let isTableContact = contact.compareCollision(bodyA: cl.character, bodyB: cl.desk)
        
        if isTableContact {
            deskContacts += 1
        }
        
        let isBrokenDeskContact = contact.compareCollision(bodyA: cl.character, bodyB: cl.brokenDesk)
        
        if isBrokenDeskContact {
            brokenDeskContacts += 1
            let desk = getBrokenDesk(contact: contact)

            guard !brokenDeskIDs.contains(desk.id.uuidString) else { return }

            brokenDeskIDs.insert(desk.id.uuidString)

            breakDesk(desk: desk)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {

        let isGroundContact = contact.compareCollision(bodyA: cl.character, bodyB: cl.ground)

        if isGroundContact {
            groundContacts = max(groundContacts - 1, 0)
        }
        
        let isTableContact = contact.compareCollision(bodyA: cl.character, bodyB: cl.desk)
        
        if isTableContact {
            deskContacts = max(deskContacts - 1, 0)
        }
        
        let isBrokenDeskContact = contact.compareCollision(bodyA: cl.character, bodyB: cl.brokenDesk)
        
        if isBrokenDeskContact {
            brokenDeskContacts = max(brokenDeskContacts - 1, 0)
        }
    }
    
    func walk() {
        
    }
    
    func scale() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if !dead {
                if location.inBetween(joyStick.outerFrame.frame) {
                    joyStick.touch = touch
                    character.sprite.startWalking()
                    joyStick.isMoving = true
                }
                
                if location.inBetween(jumpButton.node.frame) {
                    jumpButton.touch = touch
                    if onDesk || onBrokenDesk {
                        character.state.isJumping = true
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !dead {
                if touch == joyStick.touch {
                    let location = touch.location(in: self)
                    
                    joyStick.touchLocation = location
                    character.state.direction = joyStick.direction
                    character.state.speed = joyStick.speed
                    
                    character.sprite.flip(character.state.direction)
                    joyStick.move()
                }
            }
        }
    }
    
    func animateDoor(_ door: SKSpriteNode, reverse: Bool = false, actions: @escaping () -> Void) {
        let doorTextures = [
            SKTexture(imageNamed: "Door_Animation-1"),
            SKTexture(imageNamed: "Door_Animation-2"),
            SKTexture(imageNamed: "Door_Animation-3"),
            SKTexture(imageNamed: "Door_Animation-4"),
            SKTexture(imageNamed: "Door_Animation-5"),
            SKTexture(imageNamed: "Door_Animation-6"),
            SKTexture(imageNamed: "Door_Animation-7")
        ]
        let disappear = SKAction.animate(with: reverse == true ? doorTextures.reversed() : doorTextures, timePerFrame: 0.15)
        door.run(disappear) {
            actions()
        }
    }
    
    func reverseDesks(array: [SKSpriteNode]) -> [CGFloat] {
        var tempArray:[CGFloat] = []
        let xPositions = array.map(\.position.x).reversed()
        for (index, xPosition) in xPositions.enumerated() {
            array[index].position.x = xPosition
            tempArray.append(xPosition)
        }
        return tempArray
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            return
        }
        
        if firstStageCompleted && character.sprite.position.x <= size.width.scale(0.15) {
            scene?.isPaused = true
            gameState.finished = true
            gameState.state = .menu
        }

        if character.sprite.position.x >= size.width.scale(0.80) && !firstStageCompleted {
            let width = size.width.scale(0.25)
            firstStageCompleted = true
            teachersDesk.removeFromParent()
            run(SKAction.wait(forDuration: 0)) {
                self.animateDoor(self.door) {
                    var xPositions = self.desks.map(\.node.position.x).reversed()
                    for (index, xPosition) in xPositions.enumerated() {
                        self.desks[index].node.position.x = xPosition
                    }
                    xPositions = self.backgroundDesks.map(\.position.x).reversed()
                    for (index, xPosition) in xPositions.enumerated() {
                        self.backgroundDesks[index].position.x = xPosition
                    }
                    self.backgroundDesks.forEach {
                        $0.run(SKAction.scaleX(to: -1.0, duration: 0.1))
                    }
                    self.desks.forEach { desk in
                        desk.node.run(SKAction.scaleX(to: -1.0, duration: 0.1))
                        if desk.type == cl.brokenDesk {
                            desk.node.texture = SKTexture(imageNamed: desk.imageName)
                            desk.node.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: desk.imageName), size: CGSize(width: desk.node.size.width * 0.1, height: desk.node.size.height * 0.1))
                            desk.node.physicsBody?.isDynamic = false
                            desk.node.physicsBody?.affectedByGravity = false
                            desk.node.physicsBody?.categoryBitMask = cl.brokenDesk
                            desk.node.physicsBody?.collisionBitMask = cl.character
                            desk.node.physicsBody?.contactTestBitMask = cl.character
                        }
                    }
                    self.brokenDeskIDs.removeAll()
                }
            }
            run(SKAction.wait(forDuration: 1)) {
                self.door.position = CGPoint(x: width, y: self.door.position.y)
                self.door.run(SKAction.scaleX(to: -1.0, duration: 0.1))
                self.animateDoor(self.door, reverse: true, actions: {
                    self.hands.forEach { hand in
                        if hand.position.x <= width {
                            hand.removeFromParent()
                        }
                    }
                })
                self.door.zPosition = ZPositions.character + 1
            }
        }
        
        
        var dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        dt = min(dt, 1.0 / 30.0)
        
        if joyStick.isMoving {
            if currentSpeed != character.state.speed {
                removeAction(forKey: "walk")
                currentSpeed = character.state.speed
                character.sprite.timePerFrame = character.state.speed == .run ? 0.08 : 0.16
                character.sprite.startWalking()
            }
            character.sprite.move(
                dt: CGFloat(dt),
                direction: character.state.direction,
                speed: character.state.speed
            )
        }

        let x = character.sprite.position.x

        if character.state.direction == .forward {
            character.sprite.position.x = min(x, outOfBounds)
        } else {
            character.sprite.position.x = max(x, outOfBounds)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !dead {
                if touch == joyStick.touch {
                    joyStick.stop()
                    character.state.speed = .idle
                    character.sprite.stopWalking()
                    joyStick.touch = nil
                }
                
                if touch == jumpButton.touch {
                    guard onDesk || onBrokenDesk else { return }
                    if character.state.isJumping {
                        let direction = character.state.direction == .forward ? 10 : -10
                        let value = character.state.speed != .idle ? direction : 0
                        character.sprite.physicsBody?.applyImpulse(CGVector(dx: value, dy: device == .phone ? 500 : 4500))
                        character.sprite.jump()
                        jumpButton.touch = nil
                    }
                }
            }
        }
    }
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "Background")
        background.zPosition = -3
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        background.position = CGPoint(x: size.width/2, y: size.height.scale(0.15)/2)
        //        addChild(background)
        SoundManager.shared.playBackgroundMusic(fileName: "horrorsound")
        addChild(background)
        addChild(joyStick.thumbstick)
        addChild(joyStick.outerFrame)
        addChild(jumpButton.node)
        characterGround()
        setupCharacter()
        createBackgroundDesks()
        door = createDoor()
        addChild(door)
        createHands()
        teachersDesk = TeachersDeskNode(size: size)
        addChild(teachersDesk)
        desks = DeskNodes(size: size)
        desks.forEach { addChild($0.node) }
        character.sprite.idle()
        currentSpeed = character.state.speed
    }
    
    func createHands() {

        let handTextures = [
            SKTexture(imageNamed: "Hands_Animations-1"),
            SKTexture(imageNamed: "Hands_Animations-2"),
            SKTexture(imageNamed: "Hands_Animations-3"),
            SKTexture(imageNamed: "Hands_Animations-4"),
            SKTexture(imageNamed: "Hands_Animations-5"),
            SKTexture(imageNamed: "Hands_Animations-6")
        ]

        let handMovement = SKAction.repeatForever(
            SKAction.animate(with: handTextures, timePerFrame: 0.12)
        )

        for y in stride(from: 0.20, through: 0.10, by: -0.10) {
            for x in stride(from: 0.0, to: 0.85, by: 0.05) {

                let hand = SKSpriteNode(texture: handTextures[0])
                hand.size = CGSize(
                    width: size.width.scale(0.5),
                    height: size.height.scale(0.4)
                )
                hand.zPosition = ZPositions.hands

                hand.position = CGPoint(
                    x: size.width.scale(x),
                    y: size.height.scale(y)
                )

                hand.run(handMovement)
                self.hands.append(hand)
                addChild(hand)
            }
        }
    }
    
    func characterGround() {
        groundLevel = size.height.scale(0.10)
        let ground = SKSpriteNode(color: .clear,
                                  size: CGSize(width: size.width, height: groundLevel))
        ground.position = CGPoint(x: size.width/2, y: size.height.scale(0.10)/2)
        ground.zPosition = ZPositions.hands
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.categoryBitMask = CollideType.ground
        ground.physicsBody?.contactTestBitMask = CollideType.character
        ground.physicsBody?.collisionBitMask = CollideType.character
        
        addChild(ground)
    }
    
    func createDoor() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "Door")
        node.size = CGSize(width: size.width.scale(0.5), height: size.height.scale(0.8))
        node.position = CGPoint(x: size.width.scale(0.75), y: size.height.scale(0.35))
        node.zPosition = 5
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
        return node
    }
    
    func createBackgroundDesks() {
        var xAxis: CGFloat = 0.82
        let deskCount = 4
        let evenAmount = CGFloat(xAxis/CGFloat(deskCount))
        xAxis = evenAmount
        let assetName = "_foreground_Assets"
        for i in 1...deskCount {
            let currentAssetName = assetName + "\(i)"
            let node = SKSpriteNode(imageNamed: currentAssetName)
            node.size = CGSize(width: size.width.scale(0.2), height: size.height.scale(0.2))
            node.position = CGPoint(x: size.width.scale(xAxis), y: size.height.scale(0.04))
            node.zPosition = ZPositions.foregroundDesks
            backgroundDesks.append(node)
            addChild(node)
            xAxis += evenAmount
        }
    }
    
    func setupCharacter() {
        let scaleFactor = device == .phone ? 0.29 : 0.37
        character.sprite.position = CGPoint(x: size.width.scale(0.15), y: size.height.scale(0.35))
        character.sprite.zPosition = ZPositions.character
        character.sprite.size = CGSize(width: size.width.scale(scaleFactor), height: size.height.scale(scaleFactor))
        
        character.sprite.physicsBody = SKPhysicsBody(rectangleOf: character.sprite.size)
        character.sprite.physicsBody?.affectedByGravity = true
        character.sprite.physicsBody?.allowsRotation = false
        
        character.sprite.physicsBody?.categoryBitMask = CollideType.character
        character.sprite.physicsBody?.contactTestBitMask = CollideType.ground
        minimumLevel = character.sprite.frame.minY
        
        addChild(character.sprite)
    }
    
    func characterMove() {
//        SoundManager.shared.playSoundEffect(fileName: "walkinonwoodfloor")
        
        
        let walkTextures = [SKTexture(imageNamed: "Pose01"),
                            SKTexture(imageNamed: "Pose02"),
                            SKTexture(imageNamed: "Pose03"),
                            SKTexture(imageNamed: "Pose04"),
                            SKTexture(imageNamed: "Pose05"),
                            SKTexture(imageNamed: "Pose06"),
                            SKTexture(imageNamed: "Pose07"),
                            SKTexture(imageNamed: "Pose08"),
                            
        ]
        let walkAnimation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        
        let moveRight = SKAction.moveBy(x: 200, y: 0, duration: 1.0)
        let moveLeft = SKAction.moveBy(x: -200, y: 0, duration: 1.0)
        
        let flipRight = SKAction.scaleX(to: 1.0, duration: 0)
        let flipLeft = SKAction.scaleX(to: -1.0, duration: 0)
        
        let sequence = SKAction.sequence ([walkAnimation, moveRight, flipLeft, moveLeft, flipRight])
        
        character.sprite.run(SKAction.repeatForever(sequence))
        character.sprite.run(SKAction.repeatForever(walkAnimation))
    }
    
    func stopMoving() {
        character.sprite.removeAllActions()
    }
    
}

//
//  Untitled.swift
//  WalkingAnimation
//
//  Created by Ajanae Murray on 1/26/26.
//

//import SpriteKit
//import AVFoundation
//
//
//class OtherScene: SKScene, SKPhysicsContactDelegate {
//    
//    let character = SKSpriteNode(imageNamed: "Pose01")
//    let moveSpeed: CGFloat = 100
//    var movingLeft = false
//    var movingRight = false
//    var isOnGround = false
//    
//    
//    
//    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
//        setupCharacter()
//        characterGround()
//        characterMove()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//        
//        
//        
//    }
//    func touchDown(atPoint pos: CGPoint) {
//        if pos.x < size.width / 2 {
//            movingLeft = true
//            movingRight = false
//            character.xScale = -abs(character.xScale)
//        } else {
//            movingLeft = false
//            movingRight = true
//            character.xScale = abs(character.xScale)
//        }
//        characterMove()
//        characterJump()
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    func touchUp(atPoint pos: CGPoint) {
//        movingLeft = false
//        movingRight = false
//        stopMoving()
//        
//    }
//    
//    func characterGround() {
//        let ground = SKSpriteNode(color: .brown,
//                                  size: CGSize(width: size.width, height: 50))
//        ground.position = CGPoint(x: size.width / 2, y: 100)
//        
//        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//        ground.physicsBody?.isDynamic = false
//        
//        ground.physicsBody?.categoryBitMask = CollideType.ground
//        ground.physicsBody?.contactTestBitMask = CollideType.character
//        ground.physicsBody?.collisionBitMask = CollideType.character
//        
//        addChild(ground)
//    }
//    
//    func setupCharacter() {
//        character.position = CGPoint(x:50, y:200)
//        character.setScale(0.5)
//        
//        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
//        character.physicsBody?.affectedByGravity = true
//        character.physicsBody?.allowsRotation = false
//        
//        character.physicsBody?.categoryBitMask = CollideType.character
//        character.physicsBody?.collisionBitMask = CollideType.ground
//        character.physicsBody?.contactTestBitMask = CollideType.ground
//
//        
//        addChild(character)
//    }
//    
//    func characterMove() {
//        character.position = CGPoint(x:50, y:200)
//        SoundManager.shared.playSoundEffect(fileName: "walkinonwoodfloor")
//        
//        
//        let walkTextures = [SKTexture(imageNamed: "Pose01"),
//                            SKTexture(imageNamed: "Pose02"),
//                            SKTexture(imageNamed: "Pose03"),
//                            SKTexture(imageNamed: "Pose04"),
//                            SKTexture(imageNamed: "Pose05"),
//                            SKTexture(imageNamed: "Pose06"),
//                            SKTexture(imageNamed: "Pose07"),
//                            SKTexture(imageNamed: "Pose08"),
//                            
//        ]
//        let walkAnimation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
//        
//        let moveRight = SKAction.moveBy(x: 200, y: 0, duration: 2.0)
//        let moveLeft = SKAction.moveBy(x: -200, y: 0, duration: 2.0)
//        
//        let flipRight = SKAction.scaleX(to: 1.0, duration: 0)
//        let flipLeft = SKAction.scaleX(to: -1.0, duration: 0)
//        
//        let sequence = SKAction.sequence ([walkAnimation, moveRight, flipLeft, moveLeft, flipRight])
//        
//        character.run(SKAction.repeatForever(sequence))
//        character.run(SKAction.repeatForever(walkAnimation))
//    }
//    
//    func stopMoving() {
//        character.removeAllActions()
//        
//    }
//    
//    func characterJump() {
//        if isOnGround {
//            character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
//            isOnGround = false
//            
//        }
//    }
//}
//
////
////  WalkingSoundEffect.swift
////  WalkingAnimation
////
////  Created by Ajanae Murray on 1/29/26.
////
//
//
