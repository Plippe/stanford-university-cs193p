//
//  ViewController.swift
//  calculator
//
//  Created by Philippe Vinchon on 27/07/2017.
//  Copyright © 2017 Philippe Vinchon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var displayValue: Double {
        set { display.text = String(newValue) }
        get { return display.text.flatMap { text in Double(text) } ?? 0 }
    }

    private var calculator = Calculator()

    var newOperation = true

    @IBAction func touchDigit(_ sender: UIButton) {
        if(newOperation) {
            newOperation = false
            display.text = sender.currentTitle!
        } else {
            display.text = display.text! + sender.currentTitle!
        }
    }

    @IBAction func touchOperation(_ sender: UIButton) {
        if(!newOperation) {
            calculator.setOperand(displayValue)
        }

        newOperation = true
        if let result = calculator.performOperation(sender.currentTitle!) {
            displayValue = result
        }
    }
    
}


