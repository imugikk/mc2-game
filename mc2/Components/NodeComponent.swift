//
//  NodeComponent.swift
//  mc2
//
//  Created by Ardli Fadhillah on 19/06/23.
//

import SpriteKit
import GameplayKit

class NodeComponent: GKComponent {
    // MARK: Properties
    let node: SKNode!
    
    // MARK: Initialization
    init(forNodeWithName nodeName : String, in scene: SKScene) {
        node = scene.childNode(withName: nodeName)
        super.init()
    }
    init(withName nodeName : String, spawnPosition: CGPoint? = nil, spawnRotation: CGFloat? = nil, parent: SKNode) {
        node = SKNode()
        node.name = nodeName
        node.position = spawnPosition ?? CGPoint.zero
        node.zRotation = spawnRotation?.toRadians() ?? 0.0
        parent.addChild(node)
        
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
}
