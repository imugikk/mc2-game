//
//  PhysicsComponent.swift
//  mc2
//
//  Created by Ardli Fadhillah on 19/06/23.
//

import SpriteKit
import GameplayKit

class PhysicsBodyComponent: GKComponent {
    // MARK: Properties
    let physicsBody: SKPhysicsBody!

    // MARK: Initialization
    init(forImageWithName imageName : String) {
        self.physicsBody = SKPhysicsBody()
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
}
