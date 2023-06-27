//
//  ContactDelegate.swift
//  mc2
//
//  Created by Ardli Fadhillah on 18/06/23.
//

import SpriteKit

struct PsxBitmask {
    static let player: UInt32 = 1
    static let bullet: UInt32 = 2
    static let obstacle: UInt32 = 4
    static let enemy: UInt32 = 8
    static let enemyBullet: UInt32 = 16
    static let ingredient: UInt32 = 32
}

class ContactManager: NSObject, SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node as? HandleContactEnter
        let nodeB = contact.bodyB.node as? HandleContactEnter
        
        nodeA?.onContactEnter(with: contact.bodyB.node)
        nodeB?.onContactEnter(with: contact.bodyA.node)
    }
    func didEnd(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node as? HandleContactExit
        let nodeB = contact.bodyB.node as? HandleContactExit
        
        nodeA?.onContactExit(with: contact.bodyB.node)
        nodeB?.onContactExit(with: contact.bodyA.node)
    }
}
