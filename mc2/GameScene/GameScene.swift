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
        
        player = childNode(withName: "player") as? Player
    }
    
    override func didMove(to view: SKView) {
        self.ObserveForGameControllers()
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
}
