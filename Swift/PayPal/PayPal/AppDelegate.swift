//
//  AppDelegate.swift
//  PayPal
//
//  Created by Joe Todd on 22/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

import UIKit

struct StateManager {
    static var accessToken = ""
    static var payerId = ""
    static var paymentId = ""
    static var paymentToken = ""
}

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connect: ChirpService?
    var apiClient: PayPalAPIClient = PayPalAPIClient()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let clientId = "PAYPAL_APP_CLIENT_ID"
        let clientSecret = "PAYPAL_APP_CLIENT_SECRET"
        
        apiClient.send(PayPalAuthenticate(clientId: clientId, clientSecret: clientSecret)) { response in
            switch response {
            case .success(let data):
                
                guard let data = data as? [String:Any] else {return}
                guard let accessToken = data["access_token"] as? String else {return}
                StateManager.accessToken = accessToken
                
            case .failure(let error):
                print(error)
            }
        }
        
        connect = ChirpService()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let connect = connect, let sdk = connect.sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                connect.stop()
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let connect = connect, let sdk = connect.sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                connect.stop()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let connect = connect, let sdk = connect.sdk {
            if sdk.state == CHIRP_CONNECT_STATE_STOPPED {
                connect.start()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let connect = connect, let sdk = connect.sdk {
            if sdk.state == CHIRP_CONNECT_STATE_STOPPED {
                connect.start()
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if let connect = connect, let sdk = connect.sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                connect.stop()
            }
        }
    }
}

