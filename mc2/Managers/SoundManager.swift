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
    private var audioEngine = AVAudioEngine()
    private var bgmPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSoundEffect(audioFileName: String, volume: Float = 1.0, randomizePitch: Bool = false) {
        guard let soundURL = Bundle.main.url(forResource: audioFileName, withExtension: nil) else {
            print("Sound file '\(audioFileName)' not found.")
            return
        }
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        if randomizePitch {
            let pitchEffect = AVAudioUnitTimePitch()
            pitchEffect.pitch = Float.random(in: -50.0...50.0)
            print(pitchEffect.pitch)
            audioEngine.attach(pitchEffect)
            
            audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
            audioEngine.connect(pitchEffect, to: audioEngine.mainMixerNode, format: nil)
        } else {
            audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: nil)
        }
        
        do {
            let audioFile = try AVAudioFile(forReading: soundURL)
            audioPlayerNode.scheduleFile(audioFile, at: nil)
            audioEngine.prepare()
            try audioEngine.start()
            
            audioPlayerNode.volume = volume
            audioPlayerNode.play()
        } catch {
            print("Failed to play sound effect: \(error)")
        }
    }
    
    func playBGM(audioFileName: String, volume: Float = 1.0) {
        guard let soundURL = Bundle.main.url(forResource: audioFileName, withExtension: nil) else {
            print("Sound file '\(audioFileName)' not found.")
            return
        }
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: soundURL)
            bgmPlayer?.volume = volume
            bgmPlayer?.numberOfLoops = -1 // Infinite loop for background music
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.play()
        } catch {
            print("Failed to play background music: \(error)")
        }
    }
    
    func pauseBGM() {
        bgmPlayer?.pause()
    }
    
    func resumeBGM() {
        bgmPlayer?.play()
    }
}





//import AVFoundation

//class SoundManager{
//    static let shared = SoundManager()
//    private var audioPlayer: AVAudioPlayer?
//    private init() { }
//
//    func playSoundEffect(audioFileName: String, volume: Float = 1.0, randomizePitch: Bool = false) {
//        guard let soundURL = Bundle.main.url(forResource: audioFileName, withExtension: nil) else {
//            print("Sound file '\(audioFileName)' not found.")
//            return
//        }
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//            audioPlayer?.volume = volume
//
//            if randomizePitch {
//                let randomPitch = Float.random(in: 0.8...1.2)
//                audioPlayer?.enableRate = true
//                audioPlayer?.rate = randomPitch
//            }
//
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//        } catch {
//            print("Failed to play sound effect: \(error)")
//        }
//    }
//
//    func playBGM(audioFileName: String, volume: Float = 1.0) {
//        guard let soundURL = Bundle.main.url(forResource: audioFileName, withExtension: nil) else {
//            print("Sound file '\(audioFileName)' not found.")
//            return
//        }
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//            audioPlayer?.volume = volume
//            audioPlayer?.numberOfLoops = -1 // Infinite loop for background music
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//        } catch {
//            print("Failed to play background music: \(error)")
//        }
//    }
//
//    func pauseBGM() {
//        audioPlayer?.pause()
//    }
//
//    func resumeBGM() {
//        audioPlayer?.play()
//    }
//}
