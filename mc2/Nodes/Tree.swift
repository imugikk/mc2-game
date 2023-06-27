//
//  Tree.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 27/06/23.
//

import SpriteKit

class Tree: SKSpriteNode, PreSpawned {
    func setup() {
        self.physicsBody?.categoryBitMask = PsxBitmask.tree
        self.physicsBody?.collisionBitMask = PsxBitmask.player
        self.physicsBody?.contactTestBitMask = PsxBitmask.bullet
    }
}
