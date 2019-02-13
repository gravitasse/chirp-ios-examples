//
//  Authenticate.swift
//  PayPal
//
//  Created by Joe Todd on 22/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

struct PayPalAuthenticate: APIRequest {
    private let basicAuth: String
    
    var endpoint: String {
        return "v1/oauth2/token"
    }
    
    var method: String {
        return "POST"
    }
    
    var body: Data {
        return "grant_type=client_credentials".data(using:.ascii, allowLossyConversion: false)!
    }
    
    var headers: [String: String] {
        return [
            "Authorization": "Basic \(self.basicAuth)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
    
    public init(clientId: String, clientSecret: String) {
        let loginString = String(format: "%@:%@", clientId, clientSecret).data(using: .utf8)!
        self.basicAuth = loginString.base64EncodedString()
    }
}
