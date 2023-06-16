//
//  BulletComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 15/06/23.
//

import SpriteKit
import GameplayKit

class BulletComponent: GKComponent {
    let node: SKSpriteNode
    let speed: CGFloat
//    var isActive: Bool = false  // Add this property
    
    init(node: SKSpriteNode, speed: CGFloat) {
        self.node = node
        self.speed = speed
        
        super.init()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: TimeInterval) {
//        if !isActive {
//            // Pause the bullet node
//            node.isPaused = true
//            return
//        }
//        let currentPosition = node.position
//        let velocity = CGVector(dx: speed * CGFloat(deltaTime), dy: 0)
//        node.position = CGPoint(x: currentPosition.x + velocity.dx, y: currentPosition.y + velocity.dy)
    }
    
}





