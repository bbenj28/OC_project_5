//
//  CalcViewController.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    let calc = Calc()

    private func updateTextView() {
        textView.text = calc.expression
    }
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        if let error = calc.addTextToExpression(sender.title(for: .normal)) {
            if error == .fatalError {
                fatalError(error.rawValue)
            } else {
                alert(error)
            }
        } else {
            updateTextView()
        }
    }
    private func alert(_ error: ErrorTypes) {
        let message = error.rawValue
        let alertVC = UIAlertController(title: "Zéro!",
                message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
