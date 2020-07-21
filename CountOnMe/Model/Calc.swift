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
    var expression: String // Expression to resolve, displayed in controller's label
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
        return newElements.last != "+" && newElements.last != "-" && newElements.last != "×" && newElements.last != "÷" && newElements.count > 0
    }
    var isFirstElementInExpression: Bool {
        return elements.count == 0
    }
    var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
    init() {
        expression = ""
    }

    // MARK: Expression modification
    /// When a button is hitten, this method get the button's title and does the action linked to :
    /// verify if the text can be added, add it, and resolve it if the button is equal.
    /// - Parameter text: the button's title.
    func addTextToExpression(_ text: String?) -> ErrorTypes? {
        if expressionHaveResult {
            expression = ""
        }
        let verifiedText = checkExistingText(text)
        if verifiedText == "" {
            return nil
        }
        if Int(verifiedText) != nil {
            addNumberToExpression(verifiedText)
            return nil
        } else {
            let error: ErrorTypes?
            switch verifiedText {
            case "=":
                error = resolveExpression()
            default:
                error = addOperatorToExpression(verifiedText)
            }
            return error
        }
    }
    // the button is a number
    private func addNumberToExpression(_ numberText: String) {
        if expressionHaveResult {
            expression = ""
        }
        expression.append(numberText)
    }
    // the button is an operator
    private func addOperatorToExpression(_ operatorText: String) -> ErrorTypes? {
        if isFirstElementInExpression {
            if operatorText == "-" {
                return addText("-")
            } else {
                return .firstElementIsAnOperator
            }
        }
        if canAddOperator {
            if operatorText != "" {
                return addText(operatorText)
            }
            return nil
        }
        if isSecondOperator && operatorText == "-" {
            return addText("-")
        }
        return .existingOperator
    }
    private func addText(_ text: String) -> ErrorTypes? {
        if isSecondOperator && text == "-" {
            expression += "\(text)"
            return nil
        }
        if isFirstElementInExpression && text == "-" {
            expression += "\(text)"
            return nil
        }
        if Int(text) != nil {
            expression += "\(text)"
            return nil
        }
        expression += " \(text) "
        return nil
    }
    private func checkExistingText(_ textInTextView: String?) -> String {
        guard let existingText = textInTextView else {
            return ""
        }
        return existingText
    }

    // MARK: Resolve expression
    private func resolveExpression() -> ErrorTypes? {
        guard expressionIsCorrect else {
            return .incorrectExpression
        }
        guard expressionHaveEnoughElement else {
            return .haveEnoughElements
        }

        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations to resolve multiplication and division
        var operatorsIndex: [Int] = []
        for index in 0...operationsToReduce.count - 1 {
            switch operationsToReduce[index] {
            case "×", "÷":
                operatorsIndex.append(index)
            default:
                break
            }
        }
        while operatorsIndex.count > 0 {
            let reductionResult = reduceOperation(operations: operationsToReduce, index: operatorsIndex.last! - 1)
            guard let newOperations: [String] = reductionResult as? [String] else {
                guard let error: ErrorTypes = reductionResult[0] as? ErrorTypes else {
                    return .fatalError
                }
                return error
            }
            operationsToReduce = newOperations
            operatorsIndex.removeLast()
        }
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let reductionResult = reduceOperation(operations: operationsToReduce, index: 0)
            guard let newOperations: [String] = reductionResult as? [String] else {
                guard let error: ErrorTypes = reductionResult[0] as? ErrorTypes else {
                    return .fatalError
                }
                return error
            }
            operationsToReduce = newOperations
        }

        expression.append(" = \(operationsToReduce.first!)")
        return nil
    }
    private func reduceOperation(operations: [String], index: Int) -> [Any] {
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
                let error: ErrorTypes = .divisionByZero
                return [error]
            }
        default:
            let error: ErrorTypes = .fatalError
            return [error]
        }
        operationsToReduce.insert("\(result)", at: indexActualisation+1)
        for _ in index...indexActualisation {
            operationsToReduce.remove(at: index)
        }
        return operationsToReduce
    }
    
}
enum ErrorTypes: String {
    case existingOperator = "Un operateur est déja mis !"
    case incorrectExpression = "Entrez une expression correcte !"
    case haveEnoughElements = "Démarrez un nouveau calcul !"
    case fatalError = "Unknown operator !"
    case firstElementIsAnOperator = "L'expression ne peut pas commencer par un opérateur qui n'est pas moins !"
    case divisionByZero = "L'opération aboutit à une division par zéro, ce qui est impossible !"
}
