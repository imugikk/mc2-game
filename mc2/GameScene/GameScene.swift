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
    
    var controllerInput = (x: 0.0, y: 0.0)
    
    var controller: GCController = GCController()
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var player: Player!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        self.ObserveForGameControllers()
        player = childNode(withName: "player") as? Player
        player.setup(killedAction: restartScene)
    }
    
    var timeOnLastFrame: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        player.movement(hInput: controllerInput.x, vInput: controllerInput.y, deltaTime: deltaTime)
    }
    
    //calculate the time difference between the current and previous frame
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 49 {
            player.decreaseHealth(damage: 1)
        }
    }
    
    func restartScene() {
        self.run (SKAction.wait (forDuration: 2)) {
            if let scene = GKScene(fileNamed: "GameScene") {
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    
                    // Copy gameplay related content over to the scene
                    sceneNode.entities = scene.entities
                    sceneNode.graphs = scene.graphs
                    
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFit
                    
                    self.view?.presentScene(sceneNode)
                }
            }
        }
    }
}
