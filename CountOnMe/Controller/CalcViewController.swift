//
//  CalcViewController.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController, CalcErrorDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    let calc = Calc()

    private func updateTextView() {
        textView.text = calc.expression
        calc.delegate = self
    }
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        calc.addTextToExpression(sender.title(for: .normal))
        updateTextView()
    }
    
    func alert(_ error: ErrorTypes) {
        let message = error.rawValue
        let alertVC = UIAlertController(title: "Zéro!",
                message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
 
}
