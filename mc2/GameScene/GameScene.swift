//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var horizontalInput: CGFloat = 0.0
    var verticalInput: CGFloat = 0.0
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var player: Player!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        player = childNode(withName: "player") as? Player
    }
    
    var timeOnLastFrame: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        player.movement(hInput: horizontalInput, vInput: verticalInput, deltaTime: deltaTime)
    }
    
    //calculate the time difference between the current and previous frame
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }
}
