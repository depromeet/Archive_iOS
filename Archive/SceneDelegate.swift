//
//  SceneDelegate.swift
//  Archive
//
//  Created by TTOzzi on 2021/09/30.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let signInViewController = UIStoryboard(name: "Onboarding", bundle: nil)
            .instantiateViewController(withIdentifier: "SignInViewController")
        window.rootViewController = signInViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
