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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.delegate = self
    }
    
    private func updateTextView() {
        textView.text = calc.expression
    }
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        calc.addTextToExpression(sender.title(for: .normal))
        print(calc.expression)
        print(calc.expression.count)
        print(calc.expression.split(separator: " "))
        print(calc.elements)
        updateTextView()
    }
    
    func alert(_ error: ErrorTypes) {
        let alertVC = UIAlertController(title: error.title(),
                                        message: error.message(), preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
 
}
