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
        calc.buttonHasBeenHitten(number)
        XCTAssert(number == calc.expression)
        XCTAssertNil(calc.error)
    }
    func testGivenExpressionIsEmpty_WhenAddANegativeNumber_ThenExpressionGetIt() {
        calc.buttonHasBeenHitten("-")
        let number = chooseNumber()
        calc.buttonHasBeenHitten(number)
        XCTAssert(calc.expression == "-\(number)")
        XCTAssert(calc.elements.count == 1)
        XCTAssertNil(calc.error)
    }
    func testGivenExpressionContainsANumber_WhenAddAnOperator_ThenExpressionGetIt() {
        let number = chooseNumber()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperator()
        calc.buttonHasBeenHitten(operat)
        XCTAssert(calc.expression == "\(number) \(operat) ")
        XCTAssertNil(calc.error)
    }

    // MARK: Errors
    func testGivenExpressionIsEmpty_WhenAddNothing_ThenExpressionGetNothing() {
        calc.buttonHasBeenHitten(nil)
        XCTAssert(calc.expression == "")
        XCTAssertNil(calc.error)
    }
    func testGivenExpressionContainsANumber_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .haveEnoughElements)
    }
    func testGivenExpressionContainsANumberAndAnOperator_WhenAddAnOperatorWhichIsNotMinus_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten("×")
        calc.buttonHasBeenHitten("×")
        XCTAssert(calc.error == .existingOperator)
    }
    func testGivenLastExpressionIsAnOperator_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperator()
        calc.buttonHasBeenHitten(operat)
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .incorrectExpression)
    }
    func testGivenAnExpressionWithoutAValidOperatorExists_WhenHitEqual_ThenFatalErrorIsDisplayed() {
        calc.expression = "2 £ 2"
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .unknownOperator)
    }
    func testGivenExpressionContainsADivisionByZero_WhenHitEqual_ThenErrorIsDisplayedAndExpressionIsErased() {
        calc.expression = "56 - 18 × 3 + 5 ÷ 0"
        calc.buttonHasBeenHitten("=")
        XCTAssert(calc.error == .divisionByZero)
    }

    // MARK: Expression resolving



            // MARK: with positive numbers
    func testGivenExpressionIs2Plus2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("+")
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "2 + 2 = 4")
    }
    func testGivenExpressionIs2Minus2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("-")
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "2 - 2 = 0")
    }
    func testGivenExpressionIs2Times2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("×")
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "2 × 2 = 4")
    }
    func testGivenExpressionIs2DividedBy2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("÷")
        calc.buttonHasBeenHitten("2")
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "2 ÷ 2 = 1")
    }
    func testGivenExpressionContainsAllOperators_WhenResolve_ThenMultiplicationAndDivisionAreResolvedFirst() {
        calc.expression = "3 + 4 × 5 - 8 ÷ 2"
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "3 + 4 × 5 - 8 ÷ 2 = 19")
    }
            // MARK: with negative numbers
    func testGivenExpressionContainsNegativeNumbers_WhenResolve_ThenResultIsCorrectWithoutError() {
        var numbers: [String] = []
        for _ in 1...10 {
            numbers.append(chooseNumber())
        }
        calc.expression = "25 + -18 × 35 + -14 ÷ -7"
        calc.buttonHasBeenHitten("=")
        XCTAssertNil(calc.error)
        XCTAssert(calc.expression == "25 + -18 × 35 + -14 ÷ -7 = -603")
    }

    // MARK: New expression
    func testGivenAResultHasBeenDisplayer_WhenAddNumber_ThenNewCalculationBegins() {
        let number = chooseNumber()
        calc.buttonHasBeenHitten(number)
        let operat = chooseOperator()
        calc.buttonHasBeenHitten(operat)
        calc.buttonHasBeenHitten(number)
        calc.buttonHasBeenHitten("=")
        calc.buttonHasBeenHitten(number)
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
