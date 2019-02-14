//
//  Payment.swift
//  PayPal
//
//  Created by Joe Todd on 22/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//
import UIKit

struct PayPalPayment: APIRequest {
    private var accessToken: String
    private var jsonData: Data
    
    var endpoint: String {
        return "v1/payments/payment"
    }
    
    var method: String {
        return "POST"
    }
    
    var body: Data {
        return self.jsonData
    }
    
    var headers: [String: String] {
        return [
            "Authorization": "Bearer " + self.accessToken,
            "Content-Type": "application/json"
        ]
    }
    
    public init(accessToken: String,
                payeeEmail: String,
                amount: String,
                currency: String,
                returnUrl: String,
                cancelUrl: String,
                description: String) {
        
        self.accessToken = accessToken
        self.jsonData = "".data(using:.ascii)!
        
        let json: [String: Any] = [
            "intent": "sale",
            "redirect_urls": [
                "return_url": returnUrl,
                "cancel_url": cancelUrl
            ],
            "payer": [
                "payment_method": "paypal"
            ],
            "transactions": [[
                "amount": [
                    "total": amount,
                    "currency": currency
                ],
                "payee": [
                    "email": payeeEmail
                ],
                "description": description
            ]]
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
            self.jsonData = jsonData
        }
    }
}
