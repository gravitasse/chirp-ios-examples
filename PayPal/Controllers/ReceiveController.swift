//
//  ReceiveController.swift
//  PayPal
//
//  Created by Joe Todd on 28/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

import UIKit


/*
 * This view allows the requestor to enter the amount
 * they wish to be paid. The payment is created using
 * PayPal REST API and broadcast using Chirp Connect.
 */
class RequestController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAmount.text = "10"
    }
    
    @IBAction func dismissKeyboard() {
        if self.requestAmount.isFirstResponder {
            self.requestAmount.resignFirstResponder()
        }
    }
    
    @IBOutlet var requestAmount: UITextField!
    @IBOutlet var requestButton: UIButton!
    
    @IBAction func requestPayment(_ sender: Any) {
        
        let apiClient = PayPalAPIClient()
        let email = UserDefaults.standard.string(forKey: "PayPalEmailAddress")!
        
        apiClient.send(PayPalPayment(
            accessToken: StateManager.accessToken,
            payeeEmail: email,
            amount: self.requestAmount.text!, currency: "GBP",
            returnUrl: "https://chirp.io",
            cancelUrl: "https://chirp.io/cancel",
            description: "P2P Payment"
        )) { response in
            switch response {
            case .success(let data):
                guard let data = data as? [String:Any] else {return}
                guard let paymentId = data["id"] as? String else {return}
                print("Payment ID: " + paymentId)
                StateManager.paymentId = paymentId
                
                guard let links = data["links"] as? [[String: String]] else {return}
                for link in links {
                    if link["method"] == "REDIRECT" {
                        guard let href = link["href"] else {return}
                        let url = URL(string: href)
                        StateManager.paymentToken = (url?.queryParameters!["token"])!
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            if let connect = appDelegate.connect {
                                let payload = StateManager.paymentToken.data(using: .utf8, allowLossyConversion: false)
                                connect.send(payload: payload!)
                            }
                        })
                    }
                }
                self.performSegue(withIdentifier: "goToReceive", sender: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


/*
 * Once the payment has been authorised by the payer, a payerID
 * is generated. This view will wait for any payerIDs and execute
 * the payment.
 */
class ReceiveController: UIViewController, ChirpDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let connect = appDelegate.connect {
            connect.delegate = self
        }
    }
    
    func onReceived(data: Data?) {
        if let data = data {
            let payerId = String(data: data, encoding: .ascii)!
            print(String(format: "Received Payer ID: %@", payerId))
            
            let apiClient = PayPalAPIClient()
            apiClient.send(PayPalExecute(
                accessToken: StateManager.accessToken,
                paymentId: StateManager.paymentId,
                payerId: payerId
            )) { response in
                switch response {
                case .success(let data):
                    print(data)
                    self.performSegue(withIdentifier: "goToReceiveSuccess", sender: nil)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Decode failed");
        }
    }
    
    func onSent(data: Data?) {}
}
