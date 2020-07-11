//
//  SceneDelegate.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 07/03/2020.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Performs conditional navigation based on whether the user has configured the app for use.
        let configured = UserDefaults.standard.bool(forKey: "configured")
        let rootViewController: UIViewController
        if configured {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            rootViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        } else {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            rootViewController = storyboard.instantiateViewController(withIdentifier: "Welcome")
        }
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}

