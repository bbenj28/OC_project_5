//
//  Calc.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calc {
    // MARK: - Attributes

    /// Delegation to ask ViewController to display an alert.
    var delegate: CalcDisplayDelegate?

    /// Expression to resolve, displayed in controller's label.
    var expression: String = "1 + 1 = 2" {
        didSet {
            delegate?.updateScreen(expression)
        }
    }

    /// Elements composing the expression.
    var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables

    /// Check that the expression doesn't finish with an operator.
    var expressionIsCorrect: Bool {
        return elements.last != "+"
            && elements.last != "-"
            && elements.last != "×"
            && elements.last != "÷"
    }

    /// Check the expression has enough elements.
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /// Check if an operator can be added.
    var canAddOperator: Bool {
        return elements.last != "+"
            && elements.last != "-"
            && elements.last != "×"
            && elements.last != "÷"
    }

    /// Check if the operator is the second one.
    var isSecondOperator: Bool {
        let newElements: [String] = elements.dropLast()
        return newElements.last != "+"
            && newElements.last != "-"
            && newElements.last != "×"
            && newElements.last != "÷"
            && newElements.count > 0
    }

    /// Check if the entry is the first element in expression.
    var isFirstElementInExpression: Bool {
        return elements.count == 0
    }

    /// Check if the expression have a result.
    var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }

    // MARK: - Hitting buttons switch

    /// When a button is hitten, this method get the button's title and does the action linked to :
    /// verify if the text can be added, add it, and resolve it if the button is equal.
    /// - Parameter text: the button's title.
    func buttonHasBeenHitten(_ title: String?) {
        // clean expression if a result has been displayed
        if expressionHaveResult {
            expression = ""
        }
        // verify the entered text
        if let verifiedText = title {
            // verify the text is not empty
            if verifiedText != "" {
                // check if the text is a number
                if Int(verifiedText) != nil {
                    expression.append(verifiedText)
                } else {
                    // check if a result has been asked
                    if verifiedText == "=" {
                        resolveExpression()
                    } else {
                        // an operator button has been hitten
                        addOperatorToExpression(verifiedText)
                    }
                }
            }
        }
    }

    // MARK: - Add operator

    /// Check if the operator can be added to expression and eventually add it.
    private func addOperatorToExpression(_ operatorText: String) {
        if canAddOperator && !isFirstElementInExpression {
            // if the operator can be added, so add it
            expression.append(" \(operatorText) ")
        } else if operatorText == "-" {
            // if the operator is -, check the negative numbers cases
            handleNegativeNumbersCase()
        } else if isFirstElementInExpression {
            // the operator can't be added because it's the first element, display an alert
            delegate?.displayAlert(.firstElementIsAnOperator)
        } else {
            // the operator can't be added after another operator, display an alert
            delegate?.displayAlert(.existingOperator)
        }
    }
    /// Check if a minus sign can be added for negative numbers.
    private func handleNegativeNumbersCase() {
        if isFirstElementInExpression {
            // the expression begins with a negative number
            expression = "-"
        } else if isSecondOperator {
            // minus is added after another operator, check if it can be added
            handleSecondOperator()
        } else {
            // button has been hitten to cancel a minus sign used for a negative number, so delete it
            expression.remove(at: expression.index(before: expression.endIndex))
        }
    }
    /// Check the last operator in expression and add or delete minus sign.
    private func handleSecondOperator() {
        // get the last operator in expression
        guard let firstOperator = elements.last else {
            delegate?.displayAlert(.missingOperator)
            return
        }
        if firstOperator == "+" {
            // + case : replace + by -
            for _ in 1...2 {
                expression.remove(at: expression.index(before: expression.endIndex))
            }
            expression.append("- ")
        } else if firstOperator == "-" {
            // - case
            if expression.count < 2 {
                // - was added as negative sign for the fist number in expression, delete it
                expression = ""
            } else {
                // - was added as an operator, replace it by +
                for _ in 1...2 {
                    expression.remove(at: expression.index(before: expression.endIndex))
                }
                expression.append("+ ")
            }
        } else {
            // × and ÷ cases : add - as a negative sign
            expression.append("-")
        }
    }

    // MARK: - Resolve expression

    /// This method is called when the equal button is hitten.
    private func resolveExpression() {
        // expression verifications : is correct && have enought elements
        guard expressionIsCorrect else {
            delegate?.displayAlert(.incorrectExpression)
            return
        }
        guard expressionHaveEnoughElement else {
            delegate?.displayAlert(.haveEnoughElements)
            return
        }
        // Priority operations : × ÷
        guard let operations = priorityOperations() else {
            // an error message has been displayed during operations
            return
        }
        // Secundary operations : + -
        guard let operationsToReduce = secundaryOperations(operations) else {
            // an error message has been displayed during operations
            return
        }
        // result
        guard let result: String = operationsToReduce.first else {
            delegate?.displayAlert(.notNumber)
            return
        }
        let newResult = result.replacingOccurrences(of: ".", with: ",")
        expression.append(" = \(newResult)")
    }

    /// Resolve multiplications and divisions.
    /// - returns: Expression elements containing multiplications and divisions results.
    /// *nil* if an error message has been displayed.
    private func priorityOperations() -> [String]? {
        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations to resolve multiplication and division
        var index: Int? = 0
        while index != nil {
            // search the first index of operationsToReduce which contains a multiplication or a division
            index = searchForPriorityOperation(operationsToReduce)
            if let verifiedIndex = index {
                // if a multiplication or a division has been found, then resolve it and reduce operationsToReduce
                if let newOperations = reduceOperation(operations: operationsToReduce, index: verifiedIndex - 1) {
                    operationsToReduce = newOperations
                } else {
                    // an error message has been displayed, so return nil
                    return nil
                }
            }
        }
        // there is no more multiplications or divisions, so return operationsToReduce
        return operationsToReduce
    }
    /// Search the first index of a multiplication or a division sign in operations passed in parameter.
    /// - parameter operations: List of elements in which the method has to find a multiplication or a division sign.
    /// - returns: The first index of a multiplication or division sign. *nil* if no such signs have been found.
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

    /// Resolve additions and substractions.
    /// - parameter operations: List of remaining elements in expression.
    /// - returns: Expression's result. *nil* if an error message has been displayed.
    private func secundaryOperations(_ operations: [String]) -> [String]? {
        var operationsToReduce = operations
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            // resolve first operation in expression and reduce operationsToReduce
            if let newOperations = reduceOperation(operations: operationsToReduce, index: 0) {
                operationsToReduce = newOperations
            } else {
                // an error message has been displayed, so return nil
                return nil
            }
        }
        // there is no more operations to resolve, so return the result
        return operationsToReduce
    }
    /// Resolve the operation which begins at the asked index, and return reduced operations.
    /// - parameter operations: List of remaining elements in expression.
    /// - parameter index: Index of the first number of the operation to resolve in operations.
    /// - returns: List of remaining elements in operations. *nil* if an error message has been displayed.
    private func reduceOperation(operations: [String], index: Int) -> [String]? {
        var operationsToReduce = operations
        guard let left = Double(operationsToReduce[index]) else {
            delegate?.displayAlert(.notNumber)
            return nil
        }
        guard let operation: Operation = Operation.determination(operationsToReduce[index + 1]) else {
            delegate?.displayAlert(.unknownOperator)
            return nil
        }
        guard let right = Double(operationsToReduce[index + 2]) else {
            delegate?.displayAlert(.notNumber)
            return nil
        }
        guard let result = operation.resolve(left, right) else {
            delegate?.displayAlert(.divisionByZero)
            return nil
        }
        operationsToReduce.insert(resultInString(result), at: index + 3)
        for _ in index...index + 2 {
            operationsToReduce.remove(at: index)
        }
        return operationsToReduce
    }
    private func resultInString(_ result: Double) -> String {
        if result < Double(Int.min) || result > Double(Int.max) {
            return "\(result)"
        } else {
            if Double(Int(result)) == result {
                return "\(Int(result))"
            } else {
                return "\(result)"
            }
        }
    }
}
