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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        (UIApplication.shared.delegate as! AppDelegate).window = window
        window?.windowScene = windowScene

        let rootViewController = WelcomeViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}
