//
//  PopupText.swift
//  mc2
//
//  Created by Ardli Fadhillah on 27/06/23.
//

import SpriteKit

class PickupText: SKNode, PreSpawned {
    private var pickupText: SKLabelNode!
    
    func setup() {
        pickupText = self.childNode(withName: "pickupText") as? SKLabelNode
    }
    
    func show(pos: CGPoint) {
        pickupText.isHidden = false
        pickupText.position = pos
        pickupText.position.y += 20
    }
    
    func hide() {
        pickupText.isHidden = true
    }
}
