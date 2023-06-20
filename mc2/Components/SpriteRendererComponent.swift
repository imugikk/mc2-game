//
//  SpriteRendererComponent.swift
//  mc2
//
//  Created by Ardli Fadhillah on 19/06/23.
//

import SpriteKit
import GameplayKit

class SpriteRendererComponent: GKComponent {
    // MARK: Properties
    let spriteNode: SKSpriteNode!
    
    // MARK: Initialization
    init(forNodeWithName nodeName : String, in scene: SKScene) {
        self.spriteNode = scene.childNode(withName: nodeName) as? SKSpriteNode
        super.init()
    }
    init(forImageWithName imageName : String) {
        self.spriteNode = SKSpriteNode(imageNamed: imageName)
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
}
