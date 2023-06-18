//
//  event.swift
//  mc2
//
//  Created by Ardli Fadhillah on 16/06/23.
//

import SpriteKit

class Event {
    private var actionClosures: [SKNode: () -> Void] = [:]
    
    func subscribe(node: SKNode, closure: @escaping () -> Void) {
        actionClosures[node] = closure
    }
    
    func unsubscribe(node: SKNode) {
        actionClosures.removeValue(forKey: node)
    }
    
    func invoke() {
        for closure in actionClosures.values {
            closure()
        }
    }
}
