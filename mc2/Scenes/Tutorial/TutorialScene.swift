//
//  TutorialScene.swift
//  mc2
//
//  Created by Michelle Annice on 27/06/23.
//

import Foundation
import SpriteKit
import GameController

class TutorialScene: Scene {
    var hasMoveScene: Bool = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //play bgm buat controller
        SoundManager.shared.playBGM(in: self, audioFileName: "MainMenu.wav")
        
        InputManager.buttonAPressed.subscribe(node: self, closure: restart)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        InputManager.buttonAPressed.unsubscribe(node: self)
    }
    
    func restart() {
        if hasMoveScene == false {
            hasMoveScene = true
            GameViewController.changeScene(to: "GameScene", in: self.view!)
        }
    }
}
