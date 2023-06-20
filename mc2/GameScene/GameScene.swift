//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit
import GameController

struct BitMask {
    static let bullet: UInt32 = 1
    static let obstacle: UInt32 = 2
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    
    lazy var componentSystems : [GKComponentSystem] = {
        return []
    }()
    
    private var controller: GCController = GCController()
    private var restartDelay = 2.0
    
    private var player: Player!
    private var weapon: Weapon!

    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        InputManager.shared.ObserveForGameControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(controllerConnected), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDisconnected), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
        player = childNode(withName: "player") as? Player
        player.setup(killedAction: restartScene)
        
        weapon = player.childNode(withName: "weaponPivot") as? Weapon
    }
    
    @objc func controllerConnected() {
        // Unpause the Game if it is currently paused
        self.isPaused = false
    }
    
    @objc func controllerDisconnected() {
        // Pause the Game if a controller is disconnected ~ This is mandated by Apple
        self.isPaused = true
    }

    func setUpEntities() {
//        let redBoxEntity = makeBoxEntity(forNodeWithName: "redBox")
//        let yellowBoxEntity = makeBoxEntity(forNodeWithName: "yellowBox", withParticleComponentNamed: "Fire")
//        let greenBoxEntity = makeBoxEntity(forNodeWithName: "greenBox", wantsPlayerControlComponent: true)
//        let blueBoxEntity = makeBoxEntity(forNodeWithName: "blueBox", wantsPlayerControlComponent: true, withParticleComponentNamed: "Sparkle")

        // Create the box entity and grab its node from the scene.
        let playerEntity = GKEntity()
        let node = NodeComponent(forNodeWithName: "player", in: self)
        let spriteRenderer = SpriteRendererComponent(forNodeWithName: "player", in: self)
        playerEntity.addComponent(node)
        playerEntity.addComponent(spriteRenderer)
        entities.append(playerEntity)
    }
    
//    func addComponentsToComponentSystems() {
//        for box in entities {
//            particleComponentSystem.addComponent(foundIn: box)
//            playerControlComponentSystem.addComponent(foundIn: box)
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)

        player.update(deltaTime: deltaTime)
        weapon.update(deltaTime: deltaTime)
    }

    //calculate the time difference between the current and previous frame
    private var timeOnLastFrame: TimeInterval = 0
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }

    override func keyDown(with event: NSEvent) {
        //Spacebar
        if event.keyCode == 49 {
            player.decreaseHealth(damage: 1)
        }
    }

    private func restartScene() {
        self.run (SKAction.wait (forDuration: restartDelay)) {
            if let scene = GKScene(fileNamed: self.getClassName()) {
                if let sceneNode = scene.rootNode as! GameScene? {
                    sceneNode.entities = scene.entities
                    sceneNode.scaleMode = .aspectFit

                    self.view?.presentScene(sceneNode)
                }
            }
        }
    }
    
    private func getClassName() -> String {
        return String(describing: type(of: self))
    }
}
