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
        case .myPageIsRequired(let cardCnt):
            return navigationToMyPageScreen(cardCnt: cardCnt)
        case .recordIsRequired:
            return navigationToRecordScreen()
        case .detailIsRequired(let data):
            return navigationToDetailScreen(data: data)
        case .homeIsRequired:
            return navigationToHomeScreen()
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
    
    private func navigationToMyPageScreen(cardCnt: Int) -> FlowContributors {
        let myPageFlow = MyPageFlow()
        
        Flows.use(myPageFlow, when: .created) { [weak self] root in
            DispatchQueue.main.async {
                root.modalPresentationStyle = .fullScreen
                self?.rootViewController.present(root, animated: false)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: myPageFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.myPageIsRequired(cardCnt))))
    }
    
    private func navigationToRecordScreen() -> FlowContributors {
        let recordFlow = RecordFlow()
        
        Flows.use(recordFlow, when: .created) { [weak self] root in
            DispatchQueue.main.async {
                root.modalPresentationStyle = .fullScreen
                self?.rootViewController.present(root, animated: false)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: recordFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.recordIsRequired)))
    }
    
    private func navigationToDetailScreen(data: ArchiveDetailInfo) -> FlowContributors {
        let detailFlow = DetailFlow()
        
        Flows.use(detailFlow, when: .created) { [weak self] root in
            DispatchQueue.main.async {
                root.modalPresentationStyle = .fullScreen
                self?.rootViewController.present(root, animated: false)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: detailFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.detailIsRequired(data))))
    }
    
    private func navigationToHomeScreen() -> FlowContributors {
        let homeFlow = HomeFlow()
        
        Flows.use(homeFlow, when: .created) { [weak self] root in
            DispatchQueue.main.async {
                root.modalPresentationStyle = .fullScreen
                self?.rootViewController.present(root, animated: false)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: homeFlow,
                                                 withNextStepper: OneStepper(withSingleStep: ArchiveStep.homeIsRequired)))
    }
}
