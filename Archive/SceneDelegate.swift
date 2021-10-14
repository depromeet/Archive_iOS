//
//  SceneDelegate.swift
//  Archive
//
//  Created by TTOzzi on 2021/09/30.
//

import UIKit
import RxFlow

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let coordinator = FlowCoordinator()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let appFlow = AppFlow()
        let appStepper = AppStepper()
        coordinator.coordinate(flow: appFlow, with: appStepper)
        Flows.use(appFlow, when: .created) { [weak self] root in
            window.rootViewController = root
            self?.window = window
            window.makeKeyAndVisible()
        }
    }
}
