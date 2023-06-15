//
//  ItemComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 14/06/23.
//

import GameplayKit

class ItemComponent: GKComponent {
    let node: SKSpriteNode
    let itemType: ItemType
    
    init(node: SKSpriteNode, itemType: ItemType = .generic) {
        self.node = node
        self.itemType = itemType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
}

enum ItemType {
    case generic
    case health
    case powerUp
}
