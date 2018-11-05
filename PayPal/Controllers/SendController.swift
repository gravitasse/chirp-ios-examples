//
//  SendController.swift
//  PayPal
//
//  Created by Joe Todd on 28/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

import UIKit
import WebKit


/*
 * This view will wait for a newly generated payment
 * token from the requestor, so that the payment can be
 * authorised.
 */
class SendingController: UIViewController, ChirpDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let connect = appDelegate.connect {
            connect.delegate = self
        }
    }
    
    func onReceived(data: Data?) {
        if let data = data {
            let payload = String(data: data, encoding: .ascii)!
            print(String(format: "Received payment token: %@", payload))
            
            StateManager.paymentToken = payload
            self.performSegue(withIdentifier: "goToSend", sender: nil)
        } else {
            print("Decode failed");
        }
    }
    
    func onSent(data: Data?) {}
}


/*
 * Controller to handle the payment authorisation step.
 * Once authorised the webview is redirected to a page containing
 * the generated payerId as a query parameter.
 */
class SendController: UIViewController, WKNavigationDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: PayPalRedirectUrl + StateManager.paymentToken)
        self.webBrowser.navigationDelegate = self
        self.webBrowser.load(URLRequest(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteString as Any);
        if let params = webView.url?.queryParameters {
            if let payerId = params["PayerID"] {
                StateManager.payerId = payerId
                self.performSegue(withIdentifier: "goToSent", sender: nil)
            }
        }
        if webView.url?.absoluteString.lowercased().range(of: "cancel") != nil {
            self.performSegue(withIdentifier: "webToHome", sender: nil)
        }
    }
        
    @IBOutlet var webBrowser: WKWebView!
}


/*
 * This view sends the payer id back to the requestor.
 */
class SentController: UIViewController, ChirpDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let connect = appDelegate.connect {
            connect.delegate = self
            let payload = StateManager.payerId.data(using: .utf8)
            connect.send(payload: payload!)
        }
    }
    
    func onSent(data: Data?) {
        self.performSegue(withIdentifier: "goToSentSuccess", sender: nil)
    }
    
    func onReceived(data: Data?) {}
}
