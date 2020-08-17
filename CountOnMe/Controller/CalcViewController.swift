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
    let calc = Calc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.delegate = self
    }
    
    private func updateTextView() {
        // eventually auto scroll textView
        let range = NSMakeRange(textView.text.count - 1, 0)
        textView.scrollRangeToVisible(range)
    }
    // View actions
    @IBAction func tappedButton(_ sender: UIButton) {
        calc.buttonHasBeenHitten(sender.title(for: .normal))
        updateTextView()
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
