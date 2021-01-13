//
//  AppDelegate.swift
//  NuveiCashierCardScannerExample
//
//  Created by Michael Kessler on 19.09.20.
//  Copyright © 2020 Nuvei. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

