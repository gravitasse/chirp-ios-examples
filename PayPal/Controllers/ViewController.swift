//
//  ViewController.swift
//  PayPal
//
//  Created by Joe Todd on 22/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

import UIKit


/*
 * This view contains the opening screen, where the
 * user can choose to send/receive payments.
 * The user is redirected to the settings page if
 * there is no email address saved in storage.
 */
class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = UserDefaults.standard.string(forKey: "PayPalEmailAddress") {} else {
            performSegue(withIdentifier: "goToSettings", sender: nil)
        }
    }

}

