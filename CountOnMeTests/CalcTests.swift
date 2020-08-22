//
//  CalcTests.swift
//  CalcTests
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe
class CalcTests: XCTestCase {
    let calc = Calc()
    
    // MARK: - Add an operator or a number
    
    func testGivenExpressionIsEmpty_WhenAddANumber_ThenExpressionGetIt() {
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        XCTAssert(calc.expression == "\(number)")
        XCTAssertNil(calc.error)
    }
    func testGivenExpressionIsEmpty_WhenAddANegativeNumber_ThenExpressionGetIt() {
        calc.buttonHasBeenHitten("-")
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        XCTAssert(calc.expression == "-\(number)")
        XCTAssert(calc.elements.count == 1)
        XCTAssertNil(calc.error)
    }
    func testGivenExpressionContainsANumber_WhenAddAnOperator_ThenExpressionGetIt() {
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperatorButton()
        calc.buttonHasBeenHitten(operat)
        XCTAssert(calc.expression == "\(number) \(operat) ")
        XCTAssertNil(calc.error)
    }

    // MARK: - Errors
    
    func testGivenExpressionIsEmpty_WhenAddNothing_ThenExpressionGetNothing() {
        calc.expression = ""
        calc.buttonHasBeenHitten(nil)
        XCTAssert(calc.expression == "")
        XCTAssert(calc.error == .missingButtonTitle)
    }
    func testGivenExpressionContainsANumber_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .haveEnoughElements)
    }
    func testGivenExpressionContainsANumberAndAnOperator_WhenAddAnOperatorWhichIsNotMinus_ThenErrorIsDisplayed() {
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperatorButton()
        calc.buttonHasBeenHitten(operat)
        calc.buttonHasBeenHitten("×")
        XCTAssert(calc.error == .existingOperator)
    }
    func testGivenLastExpressionIsAnOperator_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperatorButton()
        calc.buttonHasBeenHitten(operat)
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .incorrectExpression)
    }
    func testGivenAnExpressionWithoutAValidOperatorExists_WhenHitEqual_ThenErrorIsDisplayed() {
        calc.expression = "2 £ 2"
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .unknownOperator)
    }
    func testGivenButtonTitleIsEmpty_WhenTheButtonIsHitten_ThenErrorIsDisplayed() {
        calc.buttonHasBeenHitten("")
        XCTAssert(calc.error == .missingButtonTitle)
    }
    func testGivenExpressionIsEmpty_WhenANonMinusOperatorHasBeenHitten_ThenErrorIsDisplayed() {
        calc.expression = ""
        calc.buttonHasBeenHitten("×")
        XCTAssert(calc.error == .firstElementIsAnOperator)
    }
    func testGivenExpressionIsEmpty_WhenAskCalcToHandleASecondOperator_ThenErrorIsDisplayed() {
        calc.expression = ""
        calc.handleSecondOperator()
        XCTAssert(calc.error == .missingOperator)
    }
    func testGivenExpressionContainsADivisionByZero_WhenHitEqual_ThenErrorIsDisplayed() {
        var numbers: [String] = []
        for _ in 1...10 {
            let number = chooseNumberButton()
            numbers.append(number)
        }
        var operators: [String] = []
        for _ in 1...4 {
            let operat = chooseOperatorButton()
            operators.append(operat)
        }
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten(operators[0])
        calc.buttonHasBeenHitten(numbers[2])
        calc.buttonHasBeenHitten(numbers[3])
        calc.buttonHasBeenHitten(operators[1])
        calc.buttonHasBeenHitten(numbers[4])
        calc.buttonHasBeenHitten(numbers[5])
        calc.buttonHasBeenHitten("÷")
        calc.buttonHasBeenHitten("0")
        calc.buttonHasBeenHitten(operators[2])
        calc.buttonHasBeenHitten(numbers[6])
        calc.buttonHasBeenHitten(numbers[7])
        calc.buttonHasBeenHitten(operators[3])
        calc.buttonHasBeenHitten(numbers[8])
        calc.buttonHasBeenHitten(numbers[9])
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .divisionByZero)
    }
    func testGivenExpressionContainsAResult_WhenHitEqual_ThenErrorIsDisplayed() {
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .alreadyHaveResult)
    }
    func testGivenExpressionLeftSideContainsLetters_WhenHitEqual_ThenErrorIsDisplayed() {
        calc.expression = "brb + 18"
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .notNumber)
    }
    func testGivenExpressionRightSideContainsLetters_WhenHitEqual_ThenErrorIsDisplayed() {
        calc.expression = "05 + elb"
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .notNumber)
    }

    // MARK: - Resolve positive numbers
    
    func testGivenExpressionIsAnAddition_WhenResolve_ThenResultIsDisplayedWithoutError() {
        var numbersDouble: [Double] = []
        for _ in 1...2 {
            let number = Int.random(in: 1...9)
            numbersDouble.append(Double(number))
        }
        let numbers = numbersDouble.map({String(Int($0))})
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten("+")
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten("=")
        guard let result = calc.resultInString(numbersDouble[0] + numbersDouble[1]) else {
            XCTFail()
            return
        }
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "\(numbers[0]) + \(numbers[1]) = \(result)")
    }
    func testGivenExpressionIsASubstraction_WhenResolve_ThenResultIsDisplayedWithoutError() {
        var numbersDouble: [Double] = []
        for _ in 1...2 {
            let number = Int.random(in: 1...9)
            numbersDouble.append(Double(number))
        }
        let numbers = numbersDouble.map({String(Int($0))})
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten("=")
        guard let result = calc.resultInString(numbersDouble[0] - numbersDouble[1]) else {
            XCTFail()
            return
        }
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "\(numbers[0]) - \(numbers[1]) = \(result)")
    }
    func testGivenExpressionIsAMultiplication_WhenResolve_ThenResultIsDisplayedWithoutError() {
        var numbersDouble: [Double] = []
        for _ in 1...2 {
            let number = Int.random(in: 1...9)
            numbersDouble.append(Double(number))
        }
        let numbers = numbersDouble.map({String(Int($0))})
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten("×")
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten("=")
        guard let result = calc.resultInString(numbersDouble[0] * numbersDouble[1]) else {
            XCTFail()
            return
        }
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "\(numbers[0]) × \(numbers[1]) = \(result)")
    }
    func testGivenExpressionIsADivision_WhenResolve_ThenResultIsDisplayedWithoutError() {
        var numbersDouble: [Double] = []
        for _ in 1...2 {
            let number = Int.random(in: 1...9)
            numbersDouble.append(Double(number))
        }
        let numbers = numbersDouble.map({String(Int($0))})
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten("÷")
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten("=")
        guard let result = calc.resultInString(numbersDouble[0] / numbersDouble[1]) else {
            XCTFail()
            return
        }
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "\(numbers[0]) ÷ \(numbers[1]) = \(result)")
    }
    func testGivenExpressionContainsAllOperators_WhenResolve_ThenMultiplicationAndDivisionAreResolvedFirst() {
        var numbersDouble: [Double] = []
        for _ in 1...5 {
            let number = Int.random(in: 1...9)
            numbersDouble.append(Double(number))
        }
        let numbers = numbersDouble.map({String(Int($0))})
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten("×")
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten(numbers[2])
        calc.buttonHasBeenHitten("÷")
        calc.buttonHasBeenHitten(numbers[3])
        calc.buttonHasBeenHitten("+")
        calc.buttonHasBeenHitten(numbers[4])
        calc.buttonHasBeenHitten("=")
        guard let result = calc.resultInString(numbersDouble[0] * numbersDouble[1] - numbersDouble[2] / numbersDouble[3] + numbersDouble[4]) else {
            XCTFail()
            return
        }
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "\(numbers[0]) × \(numbers[1]) - \(numbers[2]) ÷ \(numbers[3]) + \(numbers[4]) = \(result)")
        
    }
    func testGivenExpressionContainsHugeNumbers_WhenResolve_ThenResultIsDisplayedWithoutErrors() {
        var numbers: [String] = []
        for _ in 1...30 {
            numbers.append(chooseNumberButton())
        }
        for index in 0...15 {
            calc.buttonHasBeenHitten(numbers[index])
        }
        calc.buttonHasBeenHitten("×")
        for index in 16...29 {
            calc.buttonHasBeenHitten(numbers[index])
        }
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
    }
    // MARK: - Resolve negative numbers
    
    func testGivenExpressionContainsNegativeNumbers_WhenResolve_ThenResultIsCorrectWithoutError() {
        var numbersDouble: [Double] = []
        for _ in 1...7 {
            let number = Int.random(in: 1...9)
            numbersDouble.append(Double(number))
        }
        let numbers = numbersDouble.map({String(Int($0))})
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten("×")
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten("+")
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten(numbers[2])
        calc.buttonHasBeenHitten("×")
        calc.buttonHasBeenHitten(numbers[3])
        calc.buttonHasBeenHitten("+")
        calc.buttonHasBeenHitten(numbers[4])
        calc.buttonHasBeenHitten("÷")
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten(numbers[5])
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten(numbers[6])
        calc.buttonHasBeenHitten("=")
        guard let result = calc.resultInString(numbersDouble[0] * -numbersDouble[1] - numbersDouble[2] * numbersDouble[3] + numbersDouble[4] / -numbersDouble[5] + numbersDouble[6]) else {
            XCTFail()
            return
        }
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "\(numbers[0]) × -\(numbers[1]) - \(numbers[2]) × \(numbers[3]) + \(numbers[4]) ÷ -\(numbers[5]) + \(numbers[6]) = \(result)")
    }

    // MARK: - New expression
    
    func testGivenAResultHasBeenDisplayer_WhenAddNumber_ThenNewCalculationBegins() {
        let number = chooseNumberButton()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperatorButton()
        calc.buttonHasBeenHitten(operat)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten("=")
        calc.buttonHasBeenHitten(number)
        XCTAssert(calc.expression.count == 1)
    }
    
    func testGivenExpressionIsEmpty_WhenMinusButtonIsHitten_ThenAMinusSignIsAddedToExpression() {
        calc.expression = ""
        calc.buttonHasBeenHitten("-")
        XCTAssert(calc.expression == "-")
        XCTAssertNil(calc.error)
    }
    
    func testGivenExpressionBeginsByAMinusSign_WhenMinusButtonIsHitten_ThenTheMinusSignIsCancelled() {
        calc.expression = "-"
        calc.buttonHasBeenHitten("-")
        XCTAssert(calc.expression == "")
        XCTAssertNil(calc.error)
    }
    
    // MARK: - Deleting expression
    
    func testGivenAnExpressionExists_WhenACButtonIsHitten_ExpressionIsDeleted() {
        let number = chooseNumberButton()
        let operat = chooseOperatorButton()
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten(operat)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten("AC")
        XCTAssert(calc.expression == "")
        XCTAssertNil(calc.error)
    }
    
    func testGivenAnExpressionExists_WhenCButtonIsHitten_SomeElementsAreDeleted() {
        var numbers: [String] = []
        for _ in 1...10 {
            let number = chooseNumberButton()
            numbers.append(number)
        }
        var operators: [String] = []
        for _ in 1...3 {
            let operat = chooseOperatorButton()
            operators.append(operat)
        }
        calc.buttonHasBeenHitten(numbers[0])
        calc.buttonHasBeenHitten(numbers[1])
        calc.buttonHasBeenHitten(numbers[2])
        calc.buttonHasBeenHitten(operators[0])
        calc.buttonHasBeenHitten(numbers[3])
        calc.buttonHasBeenHitten(numbers[4])
        calc.buttonHasBeenHitten(operators[1])
        calc.buttonHasBeenHitten(numbers[5])
        calc.buttonHasBeenHitten(numbers[6])
        calc.buttonHasBeenHitten(operators[2])
        calc.buttonHasBeenHitten(numbers[7])
        calc.buttonHasBeenHitten(numbers[8])
        calc.buttonHasBeenHitten(numbers[9])
        calc.buttonHasBeenHitten("=")
        for _ in 1...11 {
            calc.buttonHasBeenHitten("C")
        }
        XCTAssert(calc.expression == "\(numbers[0])\(numbers[1])\(numbers[2])")
        XCTAssertNil(calc.error)
    }
    
    

    // MARK: - Supporting Methods
    func chooseNumberButton() -> String {
        let number = Int.random(in: 1...9)
        return String(number)
    }
    func chooseOperatorButton() -> String {
        let number = Int.random(in: 0...3)
        switch number {
        case 0:
            return "+"
        case 1:
            return "×"
        case 2:
            return "÷"
        default:
            return "-"
        }
    }
}
