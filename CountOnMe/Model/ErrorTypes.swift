//
//  ErrorTypes.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 13/08/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
enum ErrorTypes: String {
    case existingOperator
    case incorrectExpression
    case haveEnoughElements
    case fatalError
    case firstElementIsAnOperator
    case divisionByZero
    
    func title() -> String {
        switch self {
        case .existingOperator:
            return "Opérateur existant"
        case .incorrectExpression:
            return "Expression incorrecte"
        case .haveEnoughElements:
            return "Eléments manquants"
        case .fatalError:
            return "Fatal error"
        case .firstElementIsAnOperator:
            return "Opérateur en premier élément"
        case .divisionByZero:
            return "Division par zéro"
        }
    }
    
    func message() -> String {
        switch self {
        case .existingOperator:
            return "Un operateur est déja mis !"
        case .incorrectExpression:
            return "Entrez une expression correcte !"
        case .haveEnoughElements:
            return "Démarrez un nouveau calcul !"
        case .fatalError:
            return "Unknown operator !"
        case .firstElementIsAnOperator:
            return "L'expression ne peut pas commencer par un opérateur qui n'est pas moins !"
        case .divisionByZero:
            return "L'opération aboutit à une division par zéro, ce qui est impossible !"
        }
    }
}
