//
//  HomeFlow.swift
//  Archive
//
//  Created by hanwe on 2021/12/10.
//

import UIKit
import RxFlow

class HomeFlow: Flow {
    
    private enum Constants {
        static let HomeStoryBoardName = "Home"
        static let HomeNavigationTitle = "나의 아카이브"
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let storyBoard = UIStoryboard(name: Constants.HomeStoryBoardName, bundle: nil)
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .homeIsRequired:
            return navigationToHomeScreen()
        default:
            return .none
        }
    }
    
    private func navigationToHomeScreen() -> FlowContributors {
        let reactor = HomeReactor()
        let homeViewController: HomeViewController = storyBoard.instantiateViewController(identifier: HomeViewController.identifier) { corder in
            return HomeViewController(coder: corder, reactor: reactor)
        }
        homeViewController.title = Constants.HomeNavigationTitle
        rootViewController.pushViewController(homeViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: homeViewController,
                                                 withNextStepper: reactor))
    }
    
}
