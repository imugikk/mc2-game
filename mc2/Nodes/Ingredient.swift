//
//  ItemComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 14/06/23.
//

import GameplayKit

class Ingredient: SKSpriteNode {
    let objectName = "ingredient"
    let spriteSize = (width: 30.0, height: 30.0)
    
    init() {
        let texture = SKTexture(imageNamed: "Star")
        super.init(texture: texture, color: .green, size: texture.size())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn(in scene: SKScene) {
        self.name = objectName
        self.size = CGSize(width: spriteSize.width, height: spriteSize.height)
        self.colorBlendFactor = 1
        self.zPosition = -5
        
        scene.addChild(self)
    }
}