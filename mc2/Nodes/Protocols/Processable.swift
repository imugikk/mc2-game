//
//  Processable.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

protocol Processable {
    var destroyed: Bool { get }
    func update(deltaTime: TimeInterval)
}
