//
//  Execute.swift
//  PayPal
//
//  Created by Joe Todd on 25/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

struct PayPalExecute: APIRequest {
    private var accessToken: String
    private let paymentId: String
    private var jsonData: Data
    
    var endpoint: String {
        return "v1/payments/payment/\(paymentId)/execute"
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
                paymentId: String,
                payerId: String) {
        
        self.accessToken = accessToken
        self.paymentId = paymentId
        self.jsonData = "".data(using:.ascii)!
        
        let json: [String: Any] = [
            "payer_id": payerId
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
            self.jsonData = jsonData
        }
    }
    
}
