//
//  Calc.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

final class Calc {
    // MARK: - Properties
    
    /// Delegation to ask ViewController to display an alert.
    weak var delegate: CalcDisplayDelegate?
    
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
    
    /// If an error is displayed, change its value for the tests file to verify the error's type
    var error: ErrorTypes?
    
    // MARK: - Handle error
    
    /// Display an error, and add the error's type in calc.error.
    /// - parameter type: The error's type to display.
    private func handleError(_ type: ErrorTypes) {
        error = type
        delegate?.displayAlert(type)
    }
    
    // MARK: - Hitting buttons switch
    
    /// When a button is hitten, this method get the button's title and does the action linked to.
    /// - Parameter text: the button's title.
    func buttonHasBeenHitten(_ title: String?) {
        guard let verifiedText = title else {
            handleError(.missingButtonTitle)
            return
        }
        guard verifiedText != "" else {
            handleError(.missingButtonTitle)
            return
        }
        if Double(verifiedText) != nil {
            addNumberToExpression(verifiedText)
        } else if verifiedText == "=" {
            resolveExpression()
        } else if verifiedText == "AC" {
            acButtonHasBeenHitten()
        } else if verifiedText == "C" {
            cButtonHasBeenHitten()
        } else {
            addOperatorToExpression(verifiedText)
        }
    }
    
    // MARK: - Add Number
    
    /// Add a number to expression.
    /// - parameter number: The number to add.
    private func addNumberToExpression(_ number: String) {
        if expressionHaveResult {
            expression = ""
        }
        expression.append(number)
    }
    
    // MARK: - Expression deletion on demand
    
    /// Actions to do when the C button is hitten.
    private func cButtonHasBeenHitten() {
        var numberToDelete: Int = 0
        if expressionHaveResult {
            if let last = elements.last {
                numberToDelete = 3 + last.count
            }
        } else {
            numberToDelete = expression.lastIndex(of: " ") == expression.index(before: expression.endIndex) ? 3:1
        }
        if numberToDelete > 0 {
            for _ in 1...numberToDelete {
                expression.remove(at: expression.index(before: expression.endIndex))
            }
        }
    }
    
    /// Action to do when the AC button is hitten.
    private func acButtonHasBeenHitten() {
        expression = ""
    }
    
    // MARK: - Add operator
    
    /// Check if the operator can be added to expression and eventually add it.
    /// - parameter operatorText: Title of the button which has been hitten by the user.
    private func addOperatorToExpression(_ operatorText: String) {
        if expressionHaveResult {
            expression = ""
        }
        if canAddOperator && !isFirstElementInExpression {
            expression.append(" \(operatorText) ")
        } else if operatorText == "-" {
            handleNegativeNumbersCase()
        } else if isFirstElementInExpression {
            handleError(.firstElementIsAnOperator)
        } else {
            handleError(.existingOperator)
        }
    }
    /// Check if a minus sign can be added for negative numbers.
    private func handleNegativeNumbersCase() {
        if isFirstElementInExpression {
            expression = "-"
        } else if isSecondOperator {
            handleSecondOperator()
        } else {
            // button has been hitten to cancel a minus sign used for a negative number, so delete it
            expression.remove(at: expression.index(before: expression.endIndex))
        }
    }
    /// Check the last operator in expression and add or delete minus sign.
    func handleSecondOperator() {
        guard let firstOperator = elements.last else {
            handleError(.missingOperator)
            return
        }
        if firstOperator == "+" {
            for _ in 1...2 {
                expression.remove(at: expression.index(before: expression.endIndex))
            }
            expression.append("- ")
        } else if firstOperator == "-" {
            for _ in 1...2 {
                expression.remove(at: expression.index(before: expression.endIndex))
            }
            expression.append("+ ")
        } else {
            // × and ÷ cases : add - as a negative sign
            expression.append("-")
        }
    }
    
    // MARK: - Resolve expression
    
    /// This method is called when the equal button is hitten.
    private func resolveExpression() {
        // expression verifications
        guard expressionIsCorrect else {
            handleError(.incorrectExpression)
            return
        }
        guard expressionHaveEnoughElement else {
            handleError(.haveEnoughElements)
            return
        }
        guard !expressionHaveResult else {
            handleError(.alreadyHaveResult)
            return
        }
        // resolve operations in expression
        guard let secundaryOperations = resolvePriorityOperations() else {
            // an error message has been displayed during operations
            return
        }
        guard let remainingResult = resolveSecundaryOperations(secundaryOperations) else {
            // an error message has been displayed during operations
            return
        }
        guard let result: String = remainingResult.first else { return }
        // result in double
        guard let doubleResult = Double(result) else { return }
        // translate result into string with a selected format
        guard let translatedResult = resultInString(doubleResult) else { return }
        expression.append(" = \(translatedResult)")
    }
    
    /// Resolve multiplications and divisions.
    /// - returns: Expression elements containing multiplications and divisions results.
    /// *nil* if an error message has been displayed.
    private func resolvePriorityOperations() -> [String]? {
        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations to resolve multiplication and division
        while let index = searchForPriorityOperation(operationsToReduce) {
            if let newOperations = resolveAndReduceOperation(operations: operationsToReduce, index: index - 1) {
                operationsToReduce = newOperations
            } else {
                // an error message has been displayed, so return nil
                return nil
            }
        }
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
    private func resolveSecundaryOperations(_ operations: [String]) -> [String]? {
        var operationsToReduce = operations
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            if let newOperations = resolveAndReduceOperation(operations: operationsToReduce, index: 0) {
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
    private func resolveAndReduceOperation(operations: [String], index: Int) -> [String]? {
        // create local copy of operations
        var operationsToReduce = operations
        guard let left = Double(operationsToReduce[index]) else {
            handleError(.notNumber)
            return nil
        }
        guard let operation: Operation = Operation.determination(operationsToReduce[index + 1]) else {
            handleError(.unknownOperator)
            return nil
        }
        guard let right = Double(operationsToReduce[index + 2]) else {
            handleError(.notNumber)
            return nil
        }
        // resolve operation
        guard let result = operation.resolve(left, right) else {
            handleError(.divisionByZero)
            return nil
        }
        operationsToReduce.insert(result, at: index + 3)
        // remove left, operator, and right number from operationsToReduce
        for _ in index...index + 2 {
            operationsToReduce.remove(at: index)
        }
        // return the new array
        return operationsToReduce
    }
    /// Translate a number in a formatted string.
    /// - parameter result: The number to translate.
    /// - returns: The translated string, or *nil* if an error occured.
    func resultInString(_ result: Double) -> String? {
        // create instance
        let formatter = NumberFormatter()
        // choosen formats
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        formatter.decimalSeparator = ","
        // determine the result's numberStyle based on result's size
        if result > 9999999999 {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = .none
        }
        // transform the formated number in string
        return formatter.string(for: result)
    }
    
}
