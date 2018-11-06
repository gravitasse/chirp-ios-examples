/*------------------------------------------------------------------------------
 *
 *  AppDelegate.swift
 *
 *  For full information on usage and licensing, see https://chirp.io/
 *
 *  Copyright © 2011-2018, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sdk: ChirpConnect?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sdk = ChirpConnect(appKey: APP_KEY, andSecret: APP_SECRET)
        if let sdk = sdk {
            sdk.setConfig(APP_CONFIG)
            sdk.start()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let sdk = sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                sdk.stop()
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let sdk = sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                sdk.stop()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let sdk = sdk {
            if sdk.state == CHIRP_CONNECT_STATE_STOPPED {
                sdk.start()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let sdk = sdk {
            if sdk.state == CHIRP_CONNECT_STATE_STOPPED {
                sdk.start()
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if let sdk = sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                sdk.stop()
            }
        }
    }
}
