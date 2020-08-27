//
//  CalcViewController.swift
//  CountOnMe
//
//  Created by Benjamin Breton on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class CalcViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var acButton: UIButton!
    @IBOutlet private weak var cButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - Properties
    
    /// Instance of the model.
    private let calc = Calc()
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.delegate = self
        enableCACButton()
    }
    
    // MARK: - Button is hitten
    
    /// A button has been hitten.
    /// - parameter sender: The hitten UIButton.
    @IBAction private func tappedButton(_ sender: UIButton) {
        calc.buttonHasBeenHitten(sender.title(for: .normal))
        calc.expression.count == 0 ? disableCACButtons() : enableCACButton()
        autoScrollTextView()
    }
    
    // MARK: - AutoScroll
    
    /// When expression has been changed, verify if the text has to be scrolled, and eventually scroll it.
    private func autoScrollTextView() {
        // eventually auto scroll textView
        let range = NSMakeRange(textView.text.count - 1, 0)
        textView.scrollRangeToVisible(range)
    }
    
    // MARK: - C & AC Buttons aspect
    
    /// Disable buttons and change aspect.
    private func disableCACButtons() {
        changeCACButtons(isEnabled: false, backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    /// Enable Buttons and change aspect.
    private func enableCACButton() {
        changeCACButtons(isEnabled: true, backgroundColor: #colorLiteral(red: 0.2117647059, green: 0.4352941176, blue: 0.6039215686, alpha: 1))
    }
    
    /// Enable or disable buttons and change aspect.
    private func changeCACButtons(isEnabled: Bool, backgroundColor: UIColor) {
        let buttons: [UIButton] = [cButton, acButton]
        for button in buttons {
            button.isEnabled = isEnabled
            button.backgroundColor = backgroundColor
        }
    }
}

extension CalcViewController: CalcDisplayDelegate {
    // MARK: - Delegate methods
    
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
