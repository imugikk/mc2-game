//
//  Controls.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 13/06/23.
//

import Foundation
import GameController
import SpriteKit

extension GameScene {
    
    // Function to run intially to lookout for any MFI or Remote Controllers in the area
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    // This Function is called when a controller is connected to the Apple TV
    @objc func connectControllers() {
        //Unpause the Game if it is currently paused
        self.isPaused = false
        //Used to register the Nimbus Controllers to a specific Player Number
        var indexNumber = 1
        // Run through each controller currently connected to the system
        for controller in GCController.controllers() {
        //Check to see whether it is an extended Game Controller (Such as a Nimbus)
            if controller.extendedGamepad != nil {
                controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
                indexNumber += 1
                setupControllerControls(controller: controller)
            }
        }
    }
     
    // Function called when a controller is disconnected from the Apple TV
    @objc func disconnectControllers() {
        // Pause the Game if a controller is disconnected ~ This is mandated by Apple
        self.isPaused = true
    }
    
    func setupControllerControls(controller: GCController) {
    //Function that check the controller when anything is moved or pressed on it
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            // Add movement in here for sprites of the controllers
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
    }
    
    func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int) {
        if element == gamepad.leftThumbstick{
            if index == 1 {
                controllerInput.x = Double(gamepad.leftThumbstick.xAxis.value)
                controllerInput.y = Double(gamepad.leftThumbstick.yAxis.value)
            }
            
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
                player?.handlePickupAction()
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
