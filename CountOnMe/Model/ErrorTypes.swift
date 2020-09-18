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
    case missingButtonTitle
    case alreadyHaveResult
    
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
        case .missingButtonTitle:
            return "Fatal error"
        case .alreadyHaveResult:
            return "Nouveau calcul nécessaire"
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
            return "Des éléments manquent afin de pouvoir résoudre l'opération !"
        case .unknownOperator:
            return "Un opérateur est inconnu !"
        case .notNumber:
            return "Un élément de type string n'a pas pu être converti en nombre, alors qu'il est sensé être un nombre !"
        case .firstElementIsAnOperator:
            return "L'expression ne peut pas commencer par un opérateur qui n'est pas moins !"
        case .divisionByZero:
            return "L'opération aboutit à une division par zéro, ce qui est impossible !"
        case .missingButtonTitle:
            return "Le titre du bouton est manquant, l'action n'a pas pu être résolue !"
        case .alreadyHaveResult:
            return "Démarrez un nouveau calcul !"
        }
    }
}
