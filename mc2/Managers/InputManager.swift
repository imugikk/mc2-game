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
    private var holdingRightTriggerInput = [Bool]()
    
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
    
    func isrightTriggerHeld(controllerIndex: Int) -> Bool {
        if controllerIndex >= holdingRightTriggerInput.count {
            return false
        }
        return holdingRightTriggerInput[controllerIndex]
    }
    static let buttonAPressed = Event()
    static let buttonBPressed = Event()
    static let buttonXPressed = Event()
    static let buttonYPressed = Event()
    
    var controller_1: Bool = false
    var controller_2: Bool = false
    
    // Function to run intially to lookout for any MFI or Remote Controllers in the area
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerConnected), name: NSNotification.Name.GCControllerDidConnect, object: nil)
    }
    
    @objc private func controllerConnected() {        
        var indexNumber = 0
        var foundController1 = false
        var foundController2 = false
        
        for controller in GCController.controllers() {
            //Check to see whether it is an extended Game Controller (Such as a Nimbus)
            if controller.extendedGamepad != nil {
                if indexNumber == 0 {
                    foundController1 = true
                } else if indexNumber == 1 {
                    foundController2 = true
                }
                //Register the Nimbus Controller's player index to a specific index number
                controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
                indexNumber += 1
                leftJoystickInput.append(CGPoint.zero)
                rightJoystickInput.append(CGPoint.zero)
                holdingRightTriggerInput.append(false)
                setupControllerControls(controller: controller)
                
                // Register for disconnection notification
                NotificationCenter.default.addObserver(self, selector: #selector(controllerDisconnected(_:)), name: NSNotification.Name.GCControllerDidDisconnect, object: controller)
            }
            
            controller_1 = foundController1
            controller_2 = foundController2
        }
    }
    
    @objc private func controllerDisconnected(_ notification: Notification) {
        if let controller = notification.object as? GCController {
            // Check which controller got disconnected and update the corresponding variable
            if controller.playerIndex.rawValue == 0 {
                controller_1 = false
            } else if controller.playerIndex.rawValue == 1 {
                controller_2 = false
            }
        }
    }
    
    private func setupControllerControls(controller: GCController) {
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
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
//                print("Controller: \(index) : L1")
            }
        }
        else if (element == gamepad.rightShoulder) {
            if(gamepad.rightShoulder.value != 0) {
//                print("Controller: \(index) : R1")
            }
        }
        else if (element == gamepad.leftTrigger) {
            if(gamepad.leftTrigger.value != 0) {
//                print("Controller: \(index) : L2")
            }
        }
        else if (element == gamepad.rightTrigger) {
            holdingRightTriggerInput[index] = gamepad.rightTrigger.isPressed
        }
        
        // D-Pad
        else if (gamepad.dpad == element) {
            if (gamepad.dpad.xAxis.value != 0) {
                if(gamepad.dpad.xAxis.value >= 0) {
//                    print("Controller: \(index), D-PadXAxis: kanan")
                }
                else if(gamepad.dpad.xAxis.value <= 0) {
//                    print("Controller: \(index), D-PadXAxis: kiri")
                }
            }
            else if (gamepad.dpad.yAxis.value != 0) {
                if(gamepad.dpad.yAxis.value >= 0) {
//                    print("Controller: \(index), D-PadYAxis: atas")
                }
                else if(gamepad.dpad.yAxis.value <= 0) {
//                    print("Controller: \(index), D-PadYAxis: bawah")
                }
            }
        }
        
        // A-Button
        else if (gamepad.buttonA == element) {
            if (gamepad.buttonA.value != 0) {
                InputManager.buttonAPressed.invoke()
            }
        }
        // B-Button
        else if (gamepad.buttonB == element) {
            if (gamepad.buttonB.value != 0) {
                InputManager.buttonBPressed.invoke()
            }
        }
        // X-Button
        else if (gamepad.buttonX == element) {
            if (gamepad.buttonX.value != 0) {
                InputManager.buttonXPressed.invoke()
            }
        }
        // Y-Button
        else if (gamepad.buttonY == element) {
            if (gamepad.buttonY.value != 0) {
                InputManager.buttonYPressed.invoke()
            }
        }
        
        // Menu-Button
        else if (element == gamepad.buttonMenu) {
            if(gamepad.buttonMenu.value != 0) {
//                print("Controller: \(index): menu button")
            }
        }
    }
}
