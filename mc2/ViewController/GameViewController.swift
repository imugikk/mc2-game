//
//  ViewController.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import Cocoa
import SpriteKit

class GameViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.ignoresSiblingOrder = true
        GameViewController.changeScene(to: "GameScene", in: skView)
    }
    
    static func changeScene(to sceneName: String, in view: SKView) {
        if let scene = SKScene(fileNamed: sceneName){
            scene.scaleMode = .aspectFit
            let transition = SKTransition.fade(withDuration: 0.25)
            view.presentScene(scene, transition: transition)
        }
    }
}
