//
//  ViewController.swift
//  NuveiCashierCardScannerSDK
//
//  Created by Michael Kessler on 06/09/2020.
//  Copyright © 2020 Nuvei. All rights reserved.
//

import UIKit
import WebKit

private let LAST_URL_KEY = "LAST_URL_KEY"

class ViewController: UIViewController {
    
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = UserDefaults.standard.string(forKey: LAST_URL_KEY) ?? "https://apmtest.gate2shop.com/ppp/resources/cdn/v1/scan_card/index.html"
        urlTextField.text = url
        
        let closeKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(closeKeyboardGesture)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let urlString = urlTextField.text, URL(string: urlString) != nil {
            errorLabel.text = " "
            return true
        } else {
            errorLabel.text = "* Make sure that the URL is valid"
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let urlString = urlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let url = URL(string: urlString),
            let viewController = segue.destination as? WebViewController
            else { return }
        
        view.endEditing(true)
        UserDefaults.standard.set(urlString, forKey: LAST_URL_KEY)
        
        viewController.initialURL = url
    }
}
