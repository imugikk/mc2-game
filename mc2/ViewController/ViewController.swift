//
//  ViewController.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    
    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
        }
    }
}
