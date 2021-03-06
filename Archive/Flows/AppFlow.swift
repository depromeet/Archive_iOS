//
//  AppFlow.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import UIKit
import RxSwift
import RxRelay
import RxFlow

final class AppFlow: Flow {
    
    private let rootWindow: UIWindow
    
    var root: Presentable {
        return self.rootWindow
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    init(rootWindow: UIWindow) {
        self.rootWindow = rootWindow
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else {
            return .none
        }
        
        switch step {
        case .onboardingIsRequired:
            return navigationToOnboardingScreen()
        case .homeIsRequired:
            return navigationToHomeScreen()
        case .onboardingIsComplete:
            return navigationToHomeScreen()
        case .logout:
            return navigationToOnboardingScreen()
        default:
            return .none
        }
    }
    
    private func navigationToOnboardingScreen() -> FlowContributors {
        let onboardingFlow = OnboardingFlow()
        Flows.use(onboardingFlow, when: Flows.ExecuteStrategy.ready, block: { [weak self] root in
            self?.rootWindow.rootViewController = root
            self?.rootWindow.makeKeyAndVisible()
        })
        
        return .one(flowContributor: .contribute(withNextPresentable: onboardingFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.signInIsRequired),
                                                 allowStepWhenNotPresented: false,
                                                 allowStepWhenDismissed: false))
    }
    
    private func navigationToHomeScreen() -> FlowContributors {

        let homeFlow = HomeFlow()
        Flows.use(homeFlow, when: Flows.ExecuteStrategy.ready, block: { [weak self] root in
            self?.rootWindow.rootViewController = root
            self?.rootWindow.makeKeyAndVisible()
        })
        
        return .one(flowContributor: .contribute(withNextPresentable: homeFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.homeIsRequired),
                                                 allowStepWhenNotPresented: false,
                                                 allowStepWhenDismissed: false))
    }
}
