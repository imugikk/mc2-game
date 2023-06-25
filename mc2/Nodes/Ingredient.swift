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
    
    init() {
        let texture = SKTexture(imageNamed: "Star")
        let color: NSColor = .green
        let size = CGSize(width: 30.0, height: 30.0)
        
        super.init(texture: texture, color: color, size: size)
    }
    
    func spawn(in scene: SKScene) {
        scene.addChild(self)
        
        self.name = "ingredient"
        self.colorBlendFactor = 1
        self.zPosition = -5
    }
}
