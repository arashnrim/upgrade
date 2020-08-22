//
//  AppDelegate.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 07/03/2020.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configures the Sentry library.
        SentrySDK.start { options in
            options.dsn = "https://3a2b9aa769aa4a4190cef08ea8d6f770@o419985.ingest.sentry.io/5337392"
            options.debug = true // Enabled debug when first installing is always helpful
        }

        // Performs conditional navigation based on whether the user has configured the app for use.
        let configured = UserDefaults.standard.bool(forKey: "configured")
        let rootViewController: UIViewController
        if configured {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                rootViewController = storyboard.instantiateViewController(identifier: "ViewController")
            } else {
                rootViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            }
        } else {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if #available(iOS 13.0, *) {
                rootViewController = storyboard.instantiateViewController(identifier: "Welcome")
            } else {
                rootViewController = storyboard.instantiateViewController(withIdentifier: "Welcome")
            }
        }
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
