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
}

class ContactManager: NSObject, SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node as? HandleContactEnter
        let nodeB = contact.bodyB.node as? HandleContactEnter
        
        nodeA?.onContactEnter(other: contact.bodyB.node)
        nodeB?.onContactEnter(other: contact.bodyA.node)
    }
}
