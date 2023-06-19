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
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFit
                
                // Present the scene
                if let view = self.skView {
                    view.presentScene(sceneNode)
                }
            }
        }
    }
}

