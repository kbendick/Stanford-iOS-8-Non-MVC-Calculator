//
//  ViewController.swift
//  Calculator
//
//  Created by Kyle Bendickson on 7/31/15.
//  Copyright (c) 2015 Kyle Bendickson. All rights reserved.
//

// TO DO: "Using the debugger to debug Swift in xcode 6" section discussion has no video.
//          -> Learn this on my own!

/*
    Figure out what the usage terms are for closure { $0 * $1 } !!!!

*/

/*
    MVC - Model View Controller
        
        Interactions Between Three:
                - Controller :
                        ~ Full, Unrestricted Access to talk TO Model & View
                        ~
                - Model - View Communication :
                        ~ NEVER

                - View : 
                        ~ should not own the data they display
                        ~ very little Controller communication
                            * Target outlet for action
                            * Delegate i.e. Protocol (should will did)
                            * Data Source
                                > View receives data blindly from the model via the controller

                - Model :
                        ~ Interpret and format data for the view
                        ~ Sends data changes to controller via Notification and key-value observing (KVO)
                            * Works like a radio station / pub-sub relation like in ROS

                - MVCs can work in tandem for things like multiple views on iPad, tab bar controllers, etc.
                        ~ Master / Minion relationship
*/

/*
    Alternative closure notations (note the overloaded 'in' operator):
        // With no type inference...
            { (op1: Double, op2: Double) -> Double in return op1 * op2 }
        // With type inference:
            { (op1, op2) in return op1 * op2 }
        // Using $ sign notations as the operations can be popped from stack ?????
            { $0 * $1 }
*/

/*
    switch:
        - Must cover all possible cases
        ~ Can use default to handle "the rest"
*/

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
        case "×": performBinaryOperation { $0 * $1 }
        case "÷": performBinaryOperation { $1 / $0 }
        case "+": performBinaryOperation { $0 + $1 }
        case "−": performBinaryOperation { $1 - $0 }
        case "√": performUnaryOperation { sqrt($0) }
        default: break
        }
    }
    
    func performBinaryOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performUnaryOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            // Figure out how he got to this using the documentation!!!
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

