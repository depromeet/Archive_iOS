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
    
    var root: Presentable {
        return rootViewController
    }
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else {
            return .none
        }
        
        switch step {
        case .onboardingIsRequired:
            return navigationToOnboardingScreen()
        default:
            return .none
        }
    }
    
    private func navigationToOnboardingScreen() -> FlowContributors {
        let onboardingFlow = OnboardingFlow()
        
        Flows.use(onboardingFlow, when: .created) { [weak self] root in
            DispatchQueue.main.async {
                root.modalPresentationStyle = .fullScreen
                self?.rootViewController.present(root, animated: false)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: onboardingFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.signInIsRequired)))
    }
}
