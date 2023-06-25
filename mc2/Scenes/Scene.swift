//
//  Scene.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class Scene: SKScene {
    private var timeOnLastFrame: TimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        self.update(deltaTime: deltaTime)
        
        self.traverseNodes { node in
            if let process = node as? Processable, !process.destroyed {
                process.update(deltaTime: deltaTime)
            }
        }
    }
    
    func update(deltaTime: TimeInterval) {
        
    }

    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }
}

