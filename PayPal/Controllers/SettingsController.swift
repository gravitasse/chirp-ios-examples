//
//  SettingsController.swift
//  PayPal
//
//  Created by Joe Todd on 28/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

import UIKit

/*
 * This view allows the user to enter the
 * PayPal email address they wish to send/receive
 * payments with.
 */
class SettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        if let email = UserDefaults.standard.string(forKey: "PayPalEmailAddress") {
            self.emailField.text = email
        }
    }
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBAction func save(_ sender: Any) {
        UserDefaults.standard.set(self.emailField.text, forKey: "PayPalEmailAddress")
        self.performSegue(withIdentifier: "backToHome", sender: nil)
    }
    
}
