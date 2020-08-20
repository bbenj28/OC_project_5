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
        enableCACButton()
    }
    
    private func updateTextView() {
        // eventually auto scroll textView
        let range = NSMakeRange(textView.text.count - 1, 0)
        textView.scrollRangeToVisible(range)
    }
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        calc.buttonHasBeenHitten(sender.title(for: .normal))
        enableCACButton()
        updateTextView()
    }
    @IBAction func ACButtonAction(_ sender: Any) {
        calc.ACButtonHasBeenHitten()
        disableCACButtons()
    }
    @IBAction func CButtonAction(_ sender: Any) {
        calc.CButtonHasBeenHitten()
        if calc.expression.count == 0 {
            disableCACButtons()
        } else {
            enableCACButton()
        }
    }
    func disableCACButtons() {
        let buttons: [UIButton] = [CButton, ACButton]
        for button in buttons {
            button.isEnabled = false
            button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    func enableCACButton() {
        let buttons: [UIButton] = [CButton, ACButton]
        for button in buttons {
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.4352941176, blue: 0.6039215686, alpha: 1)
        }
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
