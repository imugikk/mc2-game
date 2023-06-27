//
//  ItemComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 14/06/23.
//

import GameplayKit

class Ingredient: SKSpriteNode, HandleContactEnter, HandleContactExit {
    var pickUpText: PopupText!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Star")
        let color: NSColor = .green
        let size = CGSize(width: 30.0, height: 30.0)
        
        super.init(texture: texture, color: color, size: size)
    }
    
    func spawn(in scene: SKScene, color: NSColor) {
        scene.addChild(self)
        
        self.name = "\(color)Ingredient"
        self.colorBlendFactor = 1
        self.color = color
        self.zPosition = -5
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0 + 5.0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PsxBitmask.ingredient
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PsxBitmask.player
        
        pickUpText = scene.childNode(withName: "pickupTextParent") as? PopupText
    }
    
    func onContactEnter(with other: SKNode?) {
        if other is Chef {
            touchesPlayerBegin(chef: other as! Chef)
        }
    }
    func onContactExit(with other: SKNode?) {
        if other is Chef {
            touchesPlayerEnd(chef: other as! Chef)
        }
    }
    
    func touchesPlayerBegin(chef: Chef) {
        pickUpText.show(pos: self.position)
        chef.contactedIngredient = self
    }
    
    func touchesPlayerEnd(chef: Chef) {
        pickUpText.hide()
        chef.contactedIngredient = nil
    }
    
    func destroy() {
        self.removeFromParent()
    }
}
