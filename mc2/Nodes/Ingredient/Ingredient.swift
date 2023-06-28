//
//  ItemComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 14/06/23.
//

import SpriteKit

enum IngredientType {
    case red
    case blue
}

class Ingredient: SKSpriteNode, HandleContactEnter, HandleContactExit {
    var pickUpText: PickupText!
    var type: IngredientType!
    var stringRepresentation = ""
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Star")
        let color: NSColor = .green
        let size = CGSize(width: 30.0, height: 30.0)
        
        super.init(texture: texture, color: color, size: size)
    }
    
    func spawn(in scene: SKScene, type: IngredientType) {
        scene.addChild(self)
        
        setupType(type: type)
        self.name = "\(color.accessibilityName)Ingredient"
        self.colorBlendFactor = 1
        self.zPosition = -5
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0 + 5.0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PsxBitmask.ingredient
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PsxBitmask.player
        
        pickUpText = scene.childNode(withName: "pickupTextParent") as? PickupText
    }
    
    func spawn(in node: SKNode, type: IngredientType) {
        node.addChild(self)
        
        setupType(type: type)
        self.name = "\(color.accessibilityName)Ingredient"
        self.colorBlendFactor = 1
        self.zPosition = 10
        self.position = CGPoint.zero
    }
    
    func setupType(type: IngredientType){
        self.type = type
        switch type {
        case .red:
            self.color = .red
            stringRepresentation = "R"
        case .blue:
            self.color = .blue
            stringRepresentation = "B"
        }
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
        if chef.isHoldingIngredient { return }
        
        pickUpText.show(pos: self.position)
        chef.contactedIngredient = self
    }
    
    func touchesPlayerEnd(chef: Chef) {
        if chef.isHoldingIngredient { return }
        
        pickUpText.hide()
        chef.contactedIngredient = nil
        chef.checkCollisionWIthIngredient()
    }
    
    func destroy() {
        self.removeFromParent()
    }
}
