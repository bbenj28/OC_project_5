//
//  CalcDisplayDelegate.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 13/08/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
protocol CalcDisplayDelegate {
    func displayAlert(_ error: ErrorTypes)
    func updateScreen(_ calculation: String)
}
