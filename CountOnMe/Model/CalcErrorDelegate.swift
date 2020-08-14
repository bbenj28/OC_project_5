//
//  CalcErrorDelegate.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 13/08/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
protocol CalcErrorDelegate: CalcViewController {
    func alert(_ error: ErrorTypes)
}
