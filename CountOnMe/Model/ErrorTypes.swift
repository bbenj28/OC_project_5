//
//  ErrorTypes.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 13/08/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
enum ErrorTypes {
    case existingOperator
    case incorrectExpression
    case haveEnoughElements
    case unknownOperator
    case notNumber
    case firstElementIsAnOperator
    case divisionByZero
    case missingOperator
    case translatedResult
    case missingLastElement
    
    /// Alert's title.
    var title: String {
        switch self {
        case .missingOperator:
            return "Fatal error"
        case .existingOperator:
            return "Opérateur existant"
        case .incorrectExpression:
            return "Expression incorrecte"
        case .haveEnoughElements:
            return "Eléments manquants"
        case .unknownOperator:
            return "Fatal error"
        case .notNumber:
            return "Fatal error"
        case .firstElementIsAnOperator:
            return "Opérateur en premier élément"
        case .divisionByZero:
            return "Division par zéro"
        case .translatedResult:
            return "Fatal error"
        case .missingLastElement:
            return "Fatal error"
        }
    }
    
    /// Alert's message.
    var message: String {
        switch self {
        case .missingOperator:
            return "Un opérateur aurait du se trouver en fin d'expression !"
        case .existingOperator:
            return "Un operateur est déja mis !"
        case .incorrectExpression:
            return "Entrez une expression correcte !"
        case .haveEnoughElements:
            return "Démarrez un nouveau calcul !"
        case .unknownOperator:
            return "Un opérateur est inconnu !"
        case .notNumber:
            return "Un nombre aurait du se trouver à côté de l'opérateur !"
        case .firstElementIsAnOperator:
            return "L'expression ne peut pas commencer par un opérateur qui n'est pas moins !"
        case .divisionByZero:
            return "L'opération aboutit à une division par zéro, ce qui est impossible !"
        case .translatedResult:
            return "Le résultat n'a pas pu être traduit au format texte !"
        case .missingLastElement:
            return "Le dernier élément de l'expression n'a pas pu être récupéré !"
        }
    }
}
