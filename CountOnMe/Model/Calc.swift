//
//  Calc.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
class Calc {
    var expression: String
    var elements: [String] {
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

    var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
    init() {
        expression = ""
    }
    func addTextToExpression(_ text: String?) -> ErrorTypes? {
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
    private func addNumberToExpression(_ numberAsked: String?) {
        let numberText = checkExistingText(numberAsked)
        if expressionHaveResult {
            expression = ""
        }
        expression.append(numberText)
    }
    private func checkExistingText(_ textInTextView: String?) -> String {
        guard let existingText = textInTextView else {
            return ""
        }
        return existingText
    }
    private func addOperatorToExpression(_ operatorAsked: String?) -> ErrorTypes? {
        let operatorText = checkExistingText(operatorAsked)
        if canAddOperator {
            if operatorText != "" {
                expression += " \(operatorText) "
            }
            return nil
        } else {
            return .existingOperator
        }
    }
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
            let index = operatorsIndex[0]
            let left = Int(operationsToReduce[index-1])!
            let operand = operationsToReduce[index]
            let right = Int(operationsToReduce[index+1])!
            
            
            let result: Int
            if operand == "×" {
                result = left * right
            } else {
                result = left / right
            }
            for _ in 1...3 {
                operationsToReduce.remove(at: index-1)
            }
            operationsToReduce.insert("\(result)", at: index-1)
            operatorsIndex.remove(at: 0)
            
        }
 
        

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            /*
            print(operationsToReduce.count)
            var index: Int = 0
            var multiplicator: Int
            if operationsToReduce[0] == "-" {
                multiplicator = -1
                index += 1
            } else {
                multiplicator = 1
            }
            let left = Int(operationsToReduce[index])! * multiplicator
            index += 1
            let operand = operationsToReduce[index]
            index += 1
            if operationsToReduce[index] == "-" {
                multiplicator = -1
                index += 1
            } else {
                multiplicator = 1
            }
            let right = Int(operationsToReduce[index])! * multiplicator
            let result: Int
            switch operand {
            case "+":
                result = left + right
            case "-":
                result = left - right
            default:
                return .fatalError
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(index+1))
            operationsToReduce.insert("\(result)", at: 0)
 */
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            let result: Int
            switch operand {
            case "+":
                result = left + right
            case "-":
                result = left - right
            default:
                return .fatalError
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }

        expression.append(" = \(operationsToReduce.first!)")
        return nil
    }
    
    
}
enum ErrorTypes: String {
    case existingOperator = "Un operateur est déja mis !"
    case incorrectExpression = "Entrez une expression correcte !"
    case haveEnoughElements = "Démarrez un nouveau calcul !"
    case fatalError = "Unknown operator !"
}
