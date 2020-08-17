//
//  CalcViewController.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {
    @IBOutlet weak var ACButton: UIButton!
    @IBOutlet weak var CButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    let calc = Calc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.delegate = self
        CButton.isEnabled = false
        CButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ACButton.isEnabled = true
        ACButton.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.4352941176, blue: 0.6039215686, alpha: 1)
    }
    
    private func updateTextView() {
        // eventually auto scroll textView
        let range = NSMakeRange(textView.text.count - 1, 0)
        textView.scrollRangeToVisible(range)
    }
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        calc.buttonHasBeenHitten(sender.title(for: .normal))
        if calc.expressionHaveResult || calc.expression.count == 0 {
            disableButton(CButton)
        } else {
            enableButton(CButton)
        }
        if calc.expression.count == 0 {
            disableButton(ACButton)
        } else {
            enableButton(ACButton)
        }
        updateTextView()
    }
    @IBAction func ACButtonAction(_ sender: Any) {
        calc.expression = ""
        disableButton(ACButton)
        disableButton(CButton)
    }
    @IBAction func CButtonAction(_ sender: Any) {
        calc.CButtonHasBeenHitten()
        if calc.expression.count == 0 {
            disableButton(CButton)
            disableButton(ACButton)
        } else {
            enableButton(CButton)
            enableButton(ACButton)
        }
    }
    func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.4352941176, blue: 0.6039215686, alpha: 1)
    }
}

extension CalcViewController: CalcDisplayDelegate {
    func updateScreen(_ expression: String) {
        // update textView with expression's content
        textView.text = expression
    }
    func displayAlert(_ error: ErrorTypes) {
        let alertVC = UIAlertController(title: error.title,
                                        message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
