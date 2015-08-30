//
//  ViewController.swift
//  CalculatorOfStack
//
//  Created by zmc on 15/7/24.
//  Copyright (c) 2015年 zmc. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController
{

    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleofTyping = false
    
    @IBAction func backford(sender: UIButton) {
        // get last index of the expression that has typed in
        // get rid of the last one
        // after cancelling, 
        // if display has nothing left, let dispaly.text equals "0"
        // else let display.text equals expression current(cut the last one)

        if var expressionTyped = display.text {
            var index = advance(expressionTyped.endIndex, -1)
            if expressionTyped.hasSuffix("tan") ||  expressionTyped.hasSuffix("sin") || expressionTyped.hasSuffix("cos") {
                index = advance(expressionTyped.endIndex, -3)
                expressionTyped = expressionTyped.substringToIndex(index)
            }
            expressionTyped = expressionTyped.substringToIndex(index)
            display.text=(expressionTyped.isEmpty) ? "0":expressionTyped
            userIsInTheMiddleofTyping = display.text == "0" ? false:true
        }
    }
    
    @IBAction func clearAll(sender: UIButton) {
        display.text = "0"
        userIsInTheMiddleofTyping = false
    }
    
    @IBAction func nifixExpression(sender: UIButton) {
        let typing = sender.currentTitle!
        if userIsInTheMiddleofTyping {
            display.text = display.text! + typing
        } else {
            display.text = typing
            userIsInTheMiddleofTyping = true
        }
    }
    @IBAction func getRandom(sender: UIButton) {
       var random = Double(arc4random_uniform(1000000000))/1.0e+9
        display.text = "\(random)"
    }
    
    
    @IBAction func getResult(sender: UIButton) {
        var brain = CalculatorBrain()
        if display.text != nil {
            display.text = brain.calculate(display.text!)
        }
    }
    
 
}









