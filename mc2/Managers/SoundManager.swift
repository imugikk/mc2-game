//
//  SoundManager.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 22/06/23.
//

import SpriteKit
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var bgmAudioNode: SKAudioNode!
    
    private init() {}
    
    func playSoundEffect(in scene: SKScene, audioFileName: String, volume: Float = 1.0, randomizePitch: Bool = true) {
        
        guard let soundURL = Bundle.main.url(forResource: audioFileName, withExtension: nil) else {
            print("Sound file '\(audioFileName)' not found.")
            return
        }
        
        do{
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            let soundEffect = SKAudioNode(fileNamed: audioFileName)
            
            soundEffect.autoplayLooped = false
            soundEffect.isPositional = false
            soundEffect.run(SKAction.changeVolume(to: volume, duration: 0))
            
            if randomizePitch {
                let randomPitch = Float.random(in: 0.8...1.2)
                let pitchAction = SKAction.changePlaybackRate(to: randomPitch, duration: 0)
                soundEffect.run(pitchAction)
            }
            
            scene.addChild(soundEffect)
            let duration = audioPlayer.duration
            
            soundEffect.run(SKAction.sequence([
                SKAction.wait(forDuration: duration),
                SKAction.removeFromParent()
            ]))
            
            soundEffect.run(SKAction.play())
        } catch {
            print("Failed to create audio player: \(error)")
        }
    }
    
    func playBGM(in scene: SKScene, audioFileName: String, volume: Float = 1.0) {
        if bgmAudioNode != nil{
            bgmAudioNode.removeFromParent()
            bgmAudioNode = nil
        }
        let bgm = SKAudioNode(fileNamed: audioFileName)
        bgmAudioNode = bgm
        
        bgmAudioNode.autoplayLooped = true
        bgmAudioNode.isPositional = false
        bgmAudioNode.run(SKAction.changeVolume(to: volume, duration: 0))
        
        scene.addChild(bgmAudioNode)
    }
}

