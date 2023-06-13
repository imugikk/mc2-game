//
//  Controls.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 13/06/23.
//

import Foundation
import SpriteKit
import GameController

extension GameScene {
    func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int) {
        if element == gamepad.leftThumbstick{
            print("Left Joystick\(index): (\(gamepad.leftThumbstick.xAxis.value), \(gamepad.leftThumbstick.yAxis.value))")
        } else if (element == gamepad.rightThumbstick) {
            print("Right Joystick\(index): (\(gamepad.rightThumbstick.xAxis.value), \(gamepad.rightThumbstick.yAxis.value))")
        } else if (element == gamepad.leftShoulder) {
            if(gamepad.leftShoulder.value != 0) {
                print("Controller: \(index) : L1")
            }
        } else if (element == gamepad.rightShoulder) {
            if(gamepad.rightShoulder.value != 0) {
                print("Controller: \(index) : R1")
            }
        } else if (element == gamepad.leftTrigger) {
            if(gamepad.leftTrigger.value != 0) {
                print("Controller: \(index) : L2")
            }
        } else if (element == gamepad.rightTrigger) {
            if(gamepad.rightTrigger.value != 0) {
                print("Controller: \(index) : R2")
            }
        }
        
        // D-Pad
        else if (gamepad.dpad == element)
        {
            if (gamepad.dpad.xAxis.value != 0)
            {
                if(gamepad.dpad.xAxis.value >= 0){
                    print("Controller: \(index), D-PadXAxis: kanan")
                } else if(gamepad.dpad.xAxis.value <= 0){
                    print("Controller: \(index), D-PadXAxis: kiri")
                }
            }
            else if (gamepad.dpad.yAxis.value != 0)
            {
                if(gamepad.dpad.yAxis.value >= 0){
                    print("Controller: \(index), D-PadYAxis: atas")
                } else if(gamepad.dpad.yAxis.value <= 0){
                    print("Controller: \(index), D-PadYAxis: bawah")
                }
            }
        }
        
        // A-Button
        else if (gamepad.buttonA == element)
        {
            if (gamepad.buttonA.value != 0)
            {
                print("Controller: \(index), A-Button Pressed!")
            }
        }
        // B-Button
        else if (gamepad.buttonB == element)
        {
            if (gamepad.buttonB.value != 0)
            {
                print("Controller: \(index), B-Button Pressed!")
            }
        }
        else if (gamepad.buttonY == element)
        {
            if (gamepad.buttonY.value != 0)
            {
                print("Controller: \(index), Y-Button Pressed!")
            }
        }
        else if (gamepad.buttonX == element)
        {
            if (gamepad.buttonX.value != 0)
            {
                print("Controller: \(index), X-Button Pressed!")
            }
        }
        
        else if (element == gamepad.buttonMenu) {
            if(gamepad.buttonMenu.value != 0) {
                print("Controller: \(index): menu button")
            }
        }
    }
}
