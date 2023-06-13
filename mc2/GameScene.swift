//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var foxIdle : SKSpriteNode!
    
    //controller
    var controller: GCController = GCController()
    var isRunning = false
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
//        foxIdle = childNode(withName: "fox-idle") as? SKSpriteNode
    }
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func mouseDown(with event: NSEvent) {
//        self.touchDown(atPoint: event.location(in: self))
//    }
//
//    override func mouseDragged(with event: NSEvent) {
//        self.touchMoved(toPoint: event.location(in: self))
//    }
//
//    override func mouseUp(with event: NSEvent) {
//        self.touchUp(atPoint: event.location(in: self))
//    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            jumpingAnimation()
        case 124:
            if !isRunning {
                runningAnimation()
                isRunning = true
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 124:
            if isRunning {
                runIdleAnimation()
                isRunning = false
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func didMove(to view: SKView) {
        ObserveForGameControllers()
        
        // Create the character sprite node
        foxIdle = childNode(withName: "fox-idle") as? SKSpriteNode
        
        // Start idle animation by default
        runIdleAnimation()
    }
    
    func runIdleAnimation() {
        let idleTextures = [
            SKTexture(imageNamed: "player-idle-1"),
            SKTexture(imageNamed: "player-idle-2"),
            SKTexture(imageNamed: "player-idle-3"),
            SKTexture(imageNamed: "player-idle-4")
        ]
        
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
        let idleAction = SKAction.repeatForever(idleAnimation)
        
        foxIdle.run(idleAction, withKey: "idleAnimation")
    }
    
    func runningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "player-run-1"),
            SKTexture(imageNamed: "player-run-2"),
            SKTexture(imageNamed: "player-run-3"),
            SKTexture(imageNamed: "player-run-4"),
            SKTexture(imageNamed: "player-run-5"),
            SKTexture(imageNamed: "player-run-6")
        ]
        
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runAction = SKAction.repeatForever(runAnimation)
        
        foxIdle.run(runAction, withKey: "runAnimation")
    }
    
    func jumpingAnimation() {
        let jumpTextures = [
            SKTexture(imageNamed: "player-jump-1"),
            SKTexture(imageNamed: "player-jump-2"),
        ]
        
        let jumpAnimation = SKAction.animate(with: jumpTextures,    timePerFrame: 0.2)
        let jumpAction = SKAction.repeat(jumpAnimation, count: 1)
        
        foxIdle.run(jumpAction, withKey: "jumpAnimation")
    }
    
    // Call this method when the character starts running
    func characterStartedRunning() {
        foxIdle.removeAction(forKey: "idleAnimation")
        runningAnimation()
    }

    // Call this method when the character stops running
    func characterStoppedRunning() {
        foxIdle.removeAction(forKey: "runningAnimation")
        runIdleAnimation()
    }

    // Call this method when the character jumps
    func characterJumped() {
        foxIdle.removeAction(forKey: "idleAnimation")
        jumpingAnimation()
    }
    
    // Function to run intially to lookout for any MFI or Remote Controllers in the area
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    // This Function is called when a controller is connected to the Apple TV
    @objc func connectControllers() {
        //Unpause the Game if it is currently paused
        self.isPaused = false
        //Used to register the Nimbus Controllers to a specific Player Number
        var indexNumber = 0
        // Run through each controller currently connected to the system
        for controller in GCController.controllers() {
        //Check to see whether it is an extended Game Controller (Such as a Nimbus)
            if controller.extendedGamepad != nil {
                controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
                indexNumber += 1
                setupControllerControls(controller: controller)
            }
        }
    }
    
    // Function called when a controller is disconnected from the Apple TV
    @objc func disconnectControllers() {
        // Pause the Game if a controller is disconnected ~ This is mandated by Apple
        self.isPaused = true
    }
    
    func setupControllerControls(controller: GCController) {
    //Function that check the controller when anything is moved or pressed on it
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            // Add movement in here for sprites of the controllers
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
