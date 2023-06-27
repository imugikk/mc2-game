//
//  HandleContactEnter.swift
//  mc2
//
//  Created by Ardli Fadhillah on 26/06/23.
//

import SpriteKit

protocol HandleContactEnter {
    func onContactEnter(with other: SKNode?)
}

protocol HandleContactExit {
    func onContactExit(with other: SKNode?)
}
