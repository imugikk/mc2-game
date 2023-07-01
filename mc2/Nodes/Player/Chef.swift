//
//  Chef.swift
//  mc2
//
//  Created by Ardli Fadhillah on 27/06/23.
//

import SpriteKit

class Chef: Player {
    var contactedIngredient: Ingredient? = nil
    var heldIngredient: Ingredient? = nil
    var ingredientHolder: SKNode!
    
    var isHoldingIngredient: Bool {
        heldIngredient != nil
    }
    var isTouchingTable = false
    
    override func setup() {
        super.setup()
        
        self.moveSpeed = 212.5
        self.ingredientHolder = self.childNode(withName: "ingredientHolder")
        
        self.physicsBody?.contactTestBitMask |= PsxBitmask.ingredient
        
        InputManager.buttonAPressed.subscribe(node: self, closure: pickupOrDropIngredient)
        
        runIdleAnimation()
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        let input = InputManager.shared.getLeftJoystickInput(controllerIndex: inputIndex)
        
        playerAnimation(inputController: input)
    }
        
    func pickupOrDropIngredient() {
        if let contactedIngredient, !isHoldingIngredient {
            pickupIngredient(contactedIngredient)
        }
        else if let heldIngredient, !isTouchingTable {
            dropIngredient(heldIngredient)
        }
        else if let heldIngredient, isTouchingTable {
            placeIngredient(heldIngredient)
        }
    }
    
    func pickupIngredient(_ contactedIngredient: Ingredient) {
        let heldIngredient = Ingredient()
        heldIngredient.spawn(in: ingredientHolder, type: contactedIngredient.type)
        heldIngredient.globalPosition = ingredientHolder.globalPosition
        self.heldIngredient = heldIngredient

        contactedIngredient.pickUpText.hide()
        contactedIngredient.destroy()
        self.contactedIngredient = nil
    }
    
    func dropIngredient(_ heldIngredient: Ingredient) {
        heldIngredient.destroy()
        self.heldIngredient = nil
        
        let ingredient = Ingredient()
        ingredient.position = self.position
        ingredient.spawn(in: self.scene!, type: heldIngredient.type)
    }
    
    func placeIngredient(_ heldIngredient: Ingredient) {
        heldIngredient.destroy()
        self.heldIngredient = nil
        
        let table = scene!.childNode(withName: "table") as! Table
        table.insertIngredient(type: heldIngredient.type)
        
        table.toggleHighlight(enabled: false)
        isTouchingTable = false
        checkCollisionWIthIngredient()
    }
    
    func checkCollisionWIthIngredient() {
        if let chefBody = self.physicsBody {
            let contactedIngredients = chefBody.allContactedBodies().filter({ $0.node is Ingredient })
            if contactedIngredients.count > 0 {
                let ingredient = contactedIngredients.last!.node as! Ingredient
                ingredient.touchesPlayerBegin(chef: self)
            }
        }
    }
    
    override func destroy() {
        InputManager.buttonAPressed.unsubscribe(node: self)
        super.destroy()
    }
    
    var lastJoystickDirection: CGPoint = .zero
    var isRunning: Bool = false
    private var playerSprite: SKNode!
    func playerAnimation(inputController: CGPoint){
        let joystickPosition = CGPoint(x: inputController.x, y: inputController.y)
        let joystickActive = joystickPosition != .zero

        //animation cycle
        if joystickActive != isRunning {
            isRunning = joystickActive

            if isRunning {
                runningAnimation()
            } else {
                runIdleAnimation()
            }
        }

        //flip
        playerSprite.xScale = joystickPosition.x < 0 ? -3.5 : 3.5

        if joystickPosition != .zero {
            lastJoystickDirection = joystickPosition
        } else {
            playerSprite.xScale = lastJoystickDirection.x < 0 ? -abs(playerSprite.xScale) : abs(playerSprite.xScale)
        }
    }
    
    func runIdleAnimation() {
        let idleTextures = [
            SKTexture(imageNamed: "Karen_Idle_1"),
            SKTexture(imageNamed: "Karen_Idle_2"),
            SKTexture(imageNamed: "Karen_Idle_3"),
            SKTexture(imageNamed: "Karen_Idle_4")
        ]

        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
        let idleAction = SKAction.repeatForever(idleAnimation)
        
        playerSprite = childNode(withName: "playerSprite")!

        playerSprite.run(idleAction, withKey: "idleAnimation")
    }

    func runningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "Karen_Run_4"),
            SKTexture(imageNamed: "Karen_Run_5"),
            SKTexture(imageNamed: "Karen_Run_6"),
            SKTexture(imageNamed: "Karen_Run_7"),
            SKTexture(imageNamed: "Karen_Run_8"),
            SKTexture(imageNamed: "Karen_Run_9"),
            SKTexture(imageNamed: "Karen_Run_10"),
            SKTexture(imageNamed: "Karen_Run_11"),
            SKTexture(imageNamed: "Karen_Run_12"),
            SKTexture(imageNamed: "Karen_Run_13"),
            SKTexture(imageNamed: "Karen_Run_14"),
            SKTexture(imageNamed: "Karen_Run_15"),
            SKTexture(imageNamed: "Karen_Run_16"),
            SKTexture(imageNamed: "Karen_Run_17"),
            SKTexture(imageNamed: "Karen_Run_18"),
            SKTexture(imageNamed: "Karen_Run_1"),
            SKTexture(imageNamed: "Karen_Run_2"),
            SKTexture(imageNamed: "Karen_Run_3")
        ]

        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runAction = SKAction.repeatForever(runAnimation)
        
        playerSprite = childNode(withName: "playerSprite")!

        playerSprite.run(runAction, withKey: "runAnimation")
    }
    
    override func soundCharacter() {
        // play sfx karen hit
        SoundManager.shared.playSoundEffect(in: scene!, audioFileName: "Karen Hit.wav", volume: 1.5)
    }
}
