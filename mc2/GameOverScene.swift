//
//  GameOverScene.swift
//  mc2
//
//  Created by Michelle Annice on 16/06/23.
//

//import UIKit
import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    var entities = [GKEntity]()
    
    var restartButtonNode:SKSpriteNode!
    
    var score:Int = 0
    var highScore:Int = 0
    
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView){
        restartButtonNode = self.childNode(withName: "restartButton") as! SKSpriteNode
    }
        
    override func sceneDidLoad() {
        super.sceneDidLoad()

        scoreLabel = self.childNode(withName: "scoreText") as? SKLabelNode
        highScoreLabel = self.childNode(withName: "highScoreText") as? SKLabelNode
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        
//        if let location = touch?.location(in: self){
//            let nodesArray = self.nodes(at: location)
//            
//            if nodesArray.first?.name == "restartButton" {
//                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
//                let gameScene = GameScene(size = self.size)
//                self.view?.presentScene(gameScene, transition:transition)
//            }
//        }
//    }

    func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        highScoreLabel.text = "High Score: \(highScore)"
    }
}
