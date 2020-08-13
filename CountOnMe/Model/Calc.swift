//
//  Calc.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
class Calc {
    // MARK: Attributes
    var delegate: CalcErrorDelegate?
    var expression: String = "" // Expression to resolve, displayed in controller's label
    var elements: [String] { // elements composing the expression
        return expression.split(separator: " ").map { "\($0)" }
    }
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    var isSecondOperator: Bool {
        let newElements: [String] = elements.dropLast()
        return newElements.last != "+"
            && newElements.last != "-"
            && newElements.last != "×"
            && newElements.last != "÷"
            && newElements.count > 0
    }
    var isFirstElementInExpression: Bool {
        return elements.count == 0
    }
    var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }

    // MARK: Expression modification
    /// When a button is hitten, this method get the button's title and does the action linked to :
    /// verify if the text can be added, add it, and resolve it if the button is equal.
    /// - Parameter text: the button's title.
    func addTextToExpression(_ text: String?) {
        // clean expression if a result has been displayed
        if expressionHaveResult {
            expression = ""
        }
        // verify the entered text
        if let verifiedText = text {
            // verify the text is not empty
            if verifiedText != "" {
                // check if the text is a number
                if Int(verifiedText) != nil {
                    addNumberToExpression(verifiedText)
                } else {
                    if verifiedText == "=" {
                        resolveExpression()
                    } else {
                        addOperatorToExpression(verifiedText)
                    }
                }
            }
        }
    }
    // the button is a number
    private func addNumberToExpression(_ numberText: String) {
        expression.append(numberText)
    }
    // the button is an operator
    private func addOperatorToExpression(_ operatorText: String) {
        if isFirstElementInExpression {
            if operatorText == "-" {
                expression = "-"
            } else {
                delegate?.alert(.firstElementIsAnOperator)
            }
        } else if canAddOperator {
            expression.append(" \(operatorText) ")
        } else if isSecondOperator && operatorText == "-" {
            expression.append("-")
        } else {
            delegate?.alert(.existingOperator)
        }
    }

    // MARK: Resolve expression
    private func resolveExpression() {
        // expression verifications : is correct && have enought elements
        guard expressionIsCorrect else {
            delegate?.alert(.incorrectExpression)
            return
        }
        guard expressionHaveEnoughElement else {
            delegate?.alert(.haveEnoughElements)
            return
        }
        // Priority operations : × ÷
        guard let operations = priorityOperations() else {
            // an error message has been displayed
            return
        }
        // Secundary operations : + -
        guard let operationsToReduce = secundaryOperations(operations) else {
            // an error message has been displayed
            return
        }
        // result
        expression.append(" = \(operationsToReduce.first!)")
    }
    
    private func priorityOperations() -> [String]? {
        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations to resolve multiplication and division
        
        var okForReturn = false
        while okForReturn == false {
            if let index = searchForPriorityOperation(operationsToReduce) {
                if let newOperations = reduceOperation(operations: operationsToReduce, index: index - 1) {
                    operationsToReduce = newOperations
                } else {
                    return nil
                }
            } else {
                okForReturn = true
            }
        }
        return operationsToReduce
    }
    private func searchForPriorityOperation(_ operations: [String]) -> Int? {
        for index in 0...operations.count - 1 {
            switch operations[index] {
            case "×", "÷":
                return index
            default:
                break
            }
        }
        return nil
    }
    private func secundaryOperations(_ operations: [String]) -> [String]? {
        var operationsToReduce = operations
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            if let newOperations = reduceOperation(operations: operationsToReduce, index: 0) {
                operationsToReduce = newOperations
            } else {
                return nil
            }
        }
        return operationsToReduce
    }
    
    private func reduceOperation(operations: [String], index: Int) -> [String]? {
        var operationsToReduce = operations
        var indexActualisation = index
        var multiplicator: Int
        if operationsToReduce[indexActualisation] == "-" {
            multiplicator = -1
            indexActualisation += 1
        } else {
            multiplicator = 1
        }
        let left = Int(operationsToReduce[indexActualisation])! * multiplicator
        indexActualisation += 1
        let operand = operationsToReduce[indexActualisation]
        indexActualisation += 1
        if operationsToReduce[indexActualisation] == "-" {
            multiplicator = -1
            indexActualisation += 1
        } else {
            multiplicator = 1
        }
        let right = Int(operationsToReduce[indexActualisation])! * multiplicator
        let result: Int
        switch operand {
        case "+":
            result = left + right
        case "-":
            result = left - right
        case "×":
            result = left * right
        case "÷":
            if right != 0 {
                result = left / right
            } else {
                delegate?.alert(.divisionByZero)
                return nil
            }
        default:
            delegate?.alert(.fatalError)
            return nil
        }
        operationsToReduce.insert("\(result)", at: indexActualisation+1)
        for _ in index...indexActualisation {
            operationsToReduce.remove(at: index)
        }
        return operationsToReduce
    }
    
}

