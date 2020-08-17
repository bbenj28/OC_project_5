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
    // MARK: Add an operator or a number
    func testGivenExpressionIsEmpty_WhenAddANumber_ThenExpressionGetIt() {
        let number = chooseNumber()
        let error = calc.buttonHasBeenHitten(number)
        XCTAssert(number == calc.expression)
        XCTAssertNil(error)
    }
    func testGivenExpressionIsEmpty_WhenAddANegativeNumber_ThenExpressionGetIt() {
        let error = calc.buttonHasBeenHitten("-")
        let number = chooseNumber()
        _ = calc.buttonHasBeenHitten(number)
        XCTAssert(calc.expression == "-\(number)")
        XCTAssert(calc.elements.count == 1)
        XCTAssertNil(error)
    }
    func testGivenExpressionContainsANumber_WhenAddAnOperator_ThenExpressionGetIt() {
        let number = chooseNumber()
        _ = calc.buttonHasBeenHitten(number)
        let operat = chooseOperator()
        let error = calc.buttonHasBeenHitten(operat)
        XCTAssertNil(error)
    }

    // MARK: Errors
    func testGivenExpressionIsEmpty_WhenAddNothing_ThenExpressionGetNothing() {
        let error = calc.buttonHasBeenHitten(nil)
        XCTAssert(calc.expression == "")
        XCTAssertNil(error)
    }
    func testGivenExpressionContainsANumber_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        _ = calc.buttonHasBeenHitten(number)
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .haveEnoughElements)
    }
    func testGivenExpressionContainsANumberAndAnOperator_WhenAddAnOperatorWhichIsNotMinus_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        _ = calc.buttonHasBeenHitten(number)
        let operat = "×"
        _ = calc.buttonHasBeenHitten(operat)
        let error: ErrorTypes? = calc.addTextToExpression(operat)
        XCTAssert(error == .existingOperator)
    }
    func testGivenLastExpressionIsAnOperator_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        _ = calc.buttonHasBeenHitten(number)
        let operat = chooseOperator()
        _ = calc.buttonHasBeenHitten(operat)
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .incorrectExpression)
    }
    func testGivenAnExpressionWithoutAValidOperatorExists_WhenHitEqual_ThenFatalErrorIsDisplayed() {
        calc.expression = "2 £ 2"
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .fatalError)
    }
    func testGivenExpressionContainsADivisionByZero_WhenHitEqual_ThenErrorIsDisplayed() {
        calc.expression = "56 - 18 × 3 + 5 ÷ 0"
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .divisionByZero)
    }

    // MARK: Expression resolving



            // MARK: with positive numbers
    func testGivenExpressionIs2Plus2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "+"
        _ = calc.buttonHasBeenHitten(number)
        _ = calc.buttonHasBeenHitten(operat)
        _ = calc.buttonHasBeenHitten(number)
        let error = calc.buttonHasBeenHitten("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 + 2 = 4")
    }
    func testGivenExpressionIs2Minus2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "-"
        _ = calc.buttonHasBeenHitten(number)
        _ = calc.buttonHasBeenHitten(operat)
        _ = calc.buttonHasBeenHitten(number)
        let error = calc.buttonHasBeenHitten("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 - 2 = 0")
    }
    func testGivenExpressionIs2Times2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "×"
        _ = calc.buttonHasBeenHitten(number)
        _ = calc.buttonHasBeenHitten(operat)
        _ = calc.buttonHasBeenHitten(number)
        let error = calc.buttonHasBeenHitten("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 × 2 = 4")
    }
    func testGivenExpressionIs2DividedBy2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "÷"
        _ = calc.buttonHasBeenHitten(number)
        _ = calc.buttonHasBeenHitten(operat)
        _ = calc.buttonHasBeenHitten(number)
        let error = calc.buttonHasBeenHitten("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 ÷ 2 = 1")
    }
    func testGivenExpressionContainsAllOperators_WhenResolve_ThenMultiplicationAndDivisionAreResolvedFirst() {
        calc.expression = "3 + 4 × 5 - 8 ÷ 2"
        let error = calc.buttonHasBeenHitten("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "3 + 4 × 5 - 8 ÷ 2 = 19")
    }
            // MARK: with negative numbers
    func testGivenExpressionContainsNegativeNumbers_WhenResolve_ThenResultIsCorrectWithoutError() {
        var numbers: [String] = []
        for _ in 1...10 {
            numbers.append(chooseNumber())
        }
        _ = calc.buttonHasBeenHitten("-")
        _ = calc.buttonHasBeenHitten(numbers[0])
        _ = calc.buttonHasBeenHitten(numbers[1])
        _ = calc.buttonHasBeenHitten("+")
        _ = calc.buttonHasBeenHitten("-")
        _ = calc.buttonHasBeenHitten(numbers[2])
        _ = calc.buttonHasBeenHitten(numbers[3])
        _ = calc.buttonHasBeenHitten("×")
        _ = calc.buttonHasBeenHitten(numbers[4])
        _ = calc.buttonHasBeenHitten(numbers[5])
        _ = calc.buttonHasBeenHitten("-")
        _ = calc.buttonHasBeenHitten("-")
        _ = calc.buttonHasBeenHitten(numbers[6])
        _ = calc.buttonHasBeenHitten(numbers[7])
        _ = calc.buttonHasBeenHitten("÷")
        _ = calc.buttonHasBeenHitten("-")
        _ = calc.buttonHasBeenHitten(numbers[8])
        _ = calc.buttonHasBeenHitten(numbers[9])
        let error = calc.buttonHasBeenHitten("=")
        XCTAssertNil(error)

        var verificationNumbers: [Int] = []
        for index in 0...4 {
            let index1 = index * 2
            let index2 = index1 + 1
            verificationNumbers.append(Int(numbers[index1])! * 10 + Int(numbers[index2])!)
        }


        let multiplicationResult = (-verificationNumbers[1]) * verificationNumbers[2]
        let divisionResult = (-verificationNumbers[3]) / (-verificationNumbers[4])
        let result = (-verificationNumbers[0]) + multiplicationResult - divisionResult
        let expression = "-\(verificationNumbers[0]) + -\(verificationNumbers[1]) × \(verificationNumbers[2]) - -\(verificationNumbers[3]) ÷ -\(verificationNumbers[4]) = \(result)"
        XCTAssert(calc.expression == expression)
    }

    // MARK: New expression
    func testGivenAResultHasBeenDisplayer_WhenAddNumber_ThenNewCalculationBegins() {
        let number = chooseNumber()
        _ = calc.buttonHasBeenHitten(number)
        let operat = chooseOperator()
        _ = calc.buttonHasBeenHitten(operat)
        _ = calc.buttonHasBeenHitten(number)
        _ = calc.buttonHasBeenHitten("=")
        _ = calc.buttonHasBeenHitten(number)
        XCTAssert(calc.expression.count == 1)
    }

    // MARK: Supporting Methods
    func chooseNumber() -> String {
        let number = Int.random(in: 1...9)
        return String(number)
    }
    func chooseOperator() -> String {
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
