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
    var expression: String = "1 + 1 = 2" // Expression to resolve, displayed in controller's label
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
        if canAddOperator && !isFirstElementInExpression {
            expression.append(" \(operatorText) ")
        } else if operatorText == "-" {
            handleNegativeNumbersCase()
        } else if isFirstElementInExpression {
            delegate?.alert(.firstElementIsAnOperator)
        } else {
            delegate?.alert(.existingOperator)
        }
    }
    private func handleNegativeNumbersCase() {
        if isFirstElementInExpression {
            expression = "-"
        } else if isSecondOperator {
            handleSecondOperator()
        } else {
            expression.remove(at: expression.index(before: expression.endIndex))
        }
    }
    private func handleSecondOperator() {
        guard let firstOperator = elements.last else {
            delegate?.alert(.missingOperator)
            return
        }
        if firstOperator == "+" {
            for _ in 1...2 {
                expression.remove(at: expression.index(before: expression.endIndex))
            }
            expression.append("- ")
        } else if firstOperator == "-" {
            if expression.count < 2 {
                expression = ""
            } else {
                for _ in 1...2 {
                    expression.remove(at: expression.index(before: expression.endIndex))
                }
                expression.append("+ ")
            }
        } else {
            expression.append("-")
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
        guard let result: String = operationsToReduce.first else {
            delegate?.alert(.notNumber)
            return
        }
        let newResult = result.replacingOccurrences(of: ".", with: ",")
        expression.append(" = \(newResult)")
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
        guard let left = Double(operationsToReduce[index]) else {
            delegate?.alert(.notNumber)
            return nil
        }
        let operand = operationsToReduce[index + 1]
        guard let right = Double(operationsToReduce[index + 2]) else {
            delegate?.alert(.notNumber)
            return nil
        }
        let result: Double
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
            delegate?.alert(.unknownOperator)
            return nil
        }
        if result < Double(Int.min) || result > Double(Int.max) {
            operationsToReduce.insert("\(result)", at: index + 3)
        } else {
            if Double(Int(result)) == result {
                operationsToReduce.insert("\(Int(result))", at: index + 3)
            } else {
                operationsToReduce.insert("\(result)", at: index + 3)
            }
        }
        for _ in index...index + 2 {
            operationsToReduce.remove(at: index)
        }
        return operationsToReduce
    }
}
