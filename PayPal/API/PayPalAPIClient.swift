//
//  PayPalAPIClient.swift
//  PayPal
//
//  Created by Joe Todd on 22/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//
import Foundation


#if RELEASE
let PayPalApiUrl = "https://api.paypal.com/"
let PayPalRedirectUrl = "https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token="
#else
let PayPalApiUrl = "https://api.sandbox.paypal.com/"
let PayPalRedirectUrl = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token="
#endif


protocol APIRequest: Encodable {  
    var endpoint: String { get }
    var method: String { get }
    var body: Data { get }
    var headers: [String: String] { get }
}

public enum APIResponse<Value> {
    case success(Value)
    case failure(Error)
}
public typealias ResponseCallback<Value> = (APIResponse<Value>) -> Void


public class PayPalAPIClient {
    private let session = URLSession(configuration: .default)
    
    func send<T: APIRequest>(_ req: T, completion: @escaping ResponseCallback<Any>) {
        let endpoint = self.endpoint(for: req)
        var request = URLRequest(url: endpoint)
        request.httpMethod = req.method
        request.httpBody = req.body
        for (k, v) in req.headers {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        print(endpoint)
        print(String(data: req.body, encoding: .utf8)!)
        print(req.headers)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                        do {
                            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                            completion(.success(response))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "",
                                            code: httpResponse.statusCode,
                                            userInfo:[NSLocalizedDescriptionKey: String(data: data, encoding: .utf8)!])
                        completion(.failure(error)!)
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func endpoint<T: APIRequest>(for req: T) -> URL {
        return URL(string: "\(PayPalApiUrl)\(req.endpoint)")!
    }
}
