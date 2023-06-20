//
//  Controls.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 13/06/23.
//

import Foundation
import GameController

class InputManager {
    static let shared = InputManager()
    private init() { }
    
    private var leftJoystickInput = [CGPoint]()
    private var rightJoystickInput = [CGPoint]()
    private var isRightTriggerHeld = false
    
    func getLeftJoystickInput(controllerIndex: Int) -> CGPoint {
        if controllerIndex >= leftJoystickInput.count {
            return CGPoint.zero
        }
        return leftJoystickInput[controllerIndex]
    }
    
    func getRightJoystickInput(controllerIndex: Int) -> CGPoint {
        if controllerIndex >= rightJoystickInput.count {
            return CGPoint.zero
        }
        return rightJoystickInput[controllerIndex]
    }
    
    var rightTriggerHeld: Bool {
        return isRightTriggerHeld
    }
    
    // Function to run intially to lookout for any MFI or Remote Controllers in the area
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerConnected), name: NSNotification.Name.GCControllerDidConnect, object: nil)
    }
    
    // This Function is called when a controller is connected to the Apple TV
    @objc private func controllerConnected() {        
        //Used to register the Nimbus Controllers to a specific Player Number
        var indexNumber = 0
        // Run through each controller currently connected to the system
        for controller in GCController.controllers() {
            //Check to see whether it is an extended Game Controller (Such as a Nimbus)
            if controller.extendedGamepad != nil {
                controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
                indexNumber += 1
                leftJoystickInput.append(CGPoint.zero)
                rightJoystickInput.append(CGPoint.zero)
                setupControllerControls(controller: controller)
            }
        }
    }
    
    private func setupControllerControls(controller: GCController) {
    //Function that check the controller when anything is moved or pressed on it
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            // Add movement in here for sprites of the controllers
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
    }
    
    private func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int) {
        //Left Thumbstick
        if (element == gamepad.leftThumbstick) {
            let input = CGPoint(x: Double(gamepad.leftThumbstick.xAxis.value),
                                y: Double(gamepad.leftThumbstick.yAxis.value))
            leftJoystickInput[index] = input
        }
        //Right Thumbstick
        else if (element == gamepad.rightThumbstick) {
            let input = CGPoint(x: Double(gamepad.rightThumbstick.xAxis.value),
                                y: Double(gamepad.rightThumbstick.yAxis.value))
            rightJoystickInput[index] = input
        }
        
        //Triggers/Bumpers
        else if (element == gamepad.leftShoulder) {
            if(gamepad.leftShoulder.value != 0) {
                print("Controller: \(index) : L1")
            }
        }
        else if (element == gamepad.rightShoulder) {
            if(gamepad.rightShoulder.value != 0) {
                print("Controller: \(index) : R1")
            }
        }
        else if (element == gamepad.leftTrigger) {
            if(gamepad.leftTrigger.value != 0) {
                print("Controller: \(index) : L2")
            }
        }
        else if (element == gamepad.rightTrigger) {
            if gamepad.rightTrigger.isPressed {
                if !self.isRightTriggerHeld {
                    self.isRightTriggerHeld = true
                }
            } else {
                if self.isRightTriggerHeld {
                    self.isRightTriggerHeld = false
                }
            }
        }
        
        // D-Pad
        else if (gamepad.dpad == element) {
            if (gamepad.dpad.xAxis.value != 0) {
                if(gamepad.dpad.xAxis.value >= 0) {
                    print("Controller: \(index), D-PadXAxis: kanan")
                }
                else if(gamepad.dpad.xAxis.value <= 0) {
                    print("Controller: \(index), D-PadXAxis: kiri")
                }
            }
            else if (gamepad.dpad.yAxis.value != 0) {
                if(gamepad.dpad.yAxis.value >= 0) {
                    print("Controller: \(index), D-PadYAxis: atas")
                }
                else if(gamepad.dpad.yAxis.value <= 0) {
                    print("Controller: \(index), D-PadYAxis: bawah")
                }
            }
        }
        
        // A-Button
        else if (gamepad.buttonA == element) {
            if (gamepad.buttonA.value != 0) {
                print("Controller: \(index), A-Button Pressed!")
            }
        }
        // B-Button
        else if (gamepad.buttonB == element) {
            if (gamepad.buttonB.value != 0) {
                print("Controller: \(index), B-Button Pressed!")
            }
        }
        // X-Button
        else if (gamepad.buttonX == element) {
            if (gamepad.buttonX.value != 0) {
                print("Controller: \(index), X-Button Pressed!")
            }
        }
        // Y-Button
        else if (gamepad.buttonY == element) {
            if (gamepad.buttonY.value != 0) {
                print("Controller: \(index), Y-Button Pressed!")
            }
        }
        
        // Menu-Button
        else if (element == gamepad.buttonMenu) {
            if(gamepad.buttonMenu.value != 0) {
                print("Controller: \(index): menu button")
            }
        }
    }
}
