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
    
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        calc.buttonHasBeenHitten(sender.title(for: .normal))
        if calc.expression.count == 0 {
            disableCACButtons()
        } else {
            enableCACButton()
        }
        autoScrollTextView()
    }
    
    private func autoScrollTextView() {
        // eventually auto scroll textView
        let range = NSMakeRange(textView.text.count - 1, 0)
        textView.scrollRangeToVisible(range)
    }
    
    private func disableCACButtons() {
        changeCACButtons(isEnabled: false, backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    private func enableCACButton() {
        changeCACButtons(isEnabled: true, backgroundColor: #colorLiteral(red: 0.2117647059, green: 0.4352941176, blue: 0.6039215686, alpha: 1))
    }
    private func changeCACButtons(isEnabled: Bool, backgroundColor: UIColor) {
        let buttons: [UIButton] = [CButton, ACButton]
        for button in buttons {
            button.isEnabled = isEnabled
            button.backgroundColor = backgroundColor
        }
    }
}

extension CalcViewController: CalcDisplayDelegate {
    /// Update textView with expression's content.
    /// - parameter expression: Calc.expression.
    func updateScreen(_ expression: String) {
        textView.text = expression
    }
    
    /// Display an alert.
    /// - parameter error: Error to display.
    func displayAlert(_ error: ErrorTypes) {
        let alertVC = UIAlertController(title: error.title,
                                        message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
