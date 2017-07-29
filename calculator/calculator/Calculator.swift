//
//  Calculator.swift
//  calculator
//
//  Created by Philippe Vinchon on 29/07/2017.
//  Copyright © 2017 Philippe Vinchon. All rights reserved.
//

import Foundation

struct Calculator {

    private enum Operation {
        case unaryOperator((Double) -> Double)
        case binaryOperator((Double, Double) -> Double)
    }

    private let operations = [
        "+": Operation.binaryOperator(+),
        "-": Operation.binaryOperator(-),
        "×": Operation.binaryOperator(*),
        "÷": Operation.binaryOperator(/),
        "=": Operation.unaryOperator { return $0 },
        "﹪": Operation.unaryOperator { return $0 / 100.0 },
        "±": Operation.unaryOperator { return -$0 },
        "AC": Operation.unaryOperator { _ in 0 }
    ]

    private var accumulator: Double?
    private var pendingOperation: ((Double) -> Double)?

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }

    mutating func performOperation(_ symbol: String) -> Double? {
        if let operation = pendingOperation, let accum = accumulator {
            accumulator = operation(accum)
            pendingOperation = nil
        }

        if let operation = operations[symbol] {
            switch (operation, accumulator) {
            case (.unaryOperator(let f), .some(let accum)): accumulator = f(accum);
            case (.binaryOperator(let f), .some(let accum)):
                pendingOperation = { nextAccum in f(accum, nextAccum) }
            default: break;
            }
        } else {
            print("Operation not found \(symbol)")
        }

        return accumulator
    }

}
