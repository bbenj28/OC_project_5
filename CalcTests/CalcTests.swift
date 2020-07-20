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
    func testGivenExpressionIsEmpty_WhenAddNothing_ThenExpressionGetNothing() {
        let error = calc.addTextToExpression(nil)
        XCTAssert(calc.expression == "")
        XCTAssertNil(error)
    }
    func testGivenExpressionIsEmpty_WhenAddANumber_ThenExpressionGetIt() {
        let number = chooseNumber()
        let error = calc.addTextToExpression(number)
        XCTAssert(number == calc.expression)
        XCTAssertNil(error)
    }
    func testGivenExpressionContainsANumber_WhenAddAnOperator_ThenExpressionGetIt() {
        let number = chooseNumber()
        _ = calc.addTextToExpression(number)
        let operat = chooseOperator()
        let error = calc.addTextToExpression(operat)
        XCTAssertNil(error)
    }
    func testGivenExpressionContainsANumber_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        _ = calc.addTextToExpression(number)
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .haveEnoughElements)
    }
    func testGivenExpressionContainsANumberAndAnOperator_WhenAddAnOperator_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        _ = calc.addTextToExpression(number)
        let operat = chooseOperator()
        _ = calc.addTextToExpression(operat)
        let operat2 = chooseOperator()
        let error: ErrorTypes? = calc.addTextToExpression(operat2)
        XCTAssert(error == .existingOperator)
    }
    func testGivenExpressionIs2Plus2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "+"
        _ = calc.addTextToExpression(number)
        _ = calc.addTextToExpression(operat)
        _ = calc.addTextToExpression(number)
        let error = calc.addTextToExpression("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 + 2 = 4")
    }
    func testGivenExpressionIs2Minus2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "-"
        _ = calc.addTextToExpression(number)
        _ = calc.addTextToExpression(operat)
        _ = calc.addTextToExpression(number)
        let error = calc.addTextToExpression("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 - 2 = 0")
    }
    func testGivenExpressionIs2Times2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "×"
        _ = calc.addTextToExpression(number)
        _ = calc.addTextToExpression(operat)
        _ = calc.addTextToExpression(number)
        let error = calc.addTextToExpression("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 × 2 = 4")
    }
    func testGivenExpressionIs2DividedBy2_WhenResolve_ThenResultIsDisplayedWithoutError() {
        let number = "2"
        let operat = "÷"
        _ = calc.addTextToExpression(number)
        _ = calc.addTextToExpression(operat)
        _ = calc.addTextToExpression(number)
        let error = calc.addTextToExpression("=")
        XCTAssertNil(error)
        XCTAssert(calc.expression == "2 ÷ 2 = 1")
    }
    func testGivenLastExpressionIsAnOperator_WhenResolve_ThenErrorIsDisplayed() {
        let number = chooseNumber()
        _ = calc.addTextToExpression(number)
        let operat = chooseOperator()
        _ = calc.addTextToExpression(operat)
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .incorrectExpression)
    }
    func testGivenAResultHasBeenDisplayer_WhenAddNumber_ThenNewCalculationBegins() {
        let number = chooseNumber()
        _ = calc.addTextToExpression(number)
        let operat = chooseOperator()
        _ = calc.addTextToExpression(operat)
        _ = calc.addTextToExpression(number)
        _ = calc.addTextToExpression("=")
        _ = calc.addTextToExpression(number)
        XCTAssert(calc.expression.count == 1)
    }
    func testGivenAnExpressionWithoutAValidOperatorExists_WhenHitEqual_ThenFatalErrorIsDisplayed() {
        calc.expression = "2 £ 2"
        let error: ErrorTypes? = calc.addTextToExpression("=")
        XCTAssert(error == .fatalError)
    }
    func chooseNumber() -> String {
        let number = Int.random(in: 0...9)
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
