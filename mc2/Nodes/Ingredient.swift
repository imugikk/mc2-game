//
//  ItemComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 14/06/23.
//

import GameplayKit

class Ingredient: SKSpriteNode {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture) {
//        let texture = SKTexture(imageNamed: "Star")
        let color: NSColor = .labelColor
        let size = CGSize(width: 50.0, height: 50.0)
        
        super.init(texture: texture, color: color, size: size)
    }
    
    func spawn(in scene: SKScene) {
        scene.addChild(self)
        
        self.name = "ingredient"
        self.colorBlendFactor = 1
        self.zPosition = -5
    }
}
