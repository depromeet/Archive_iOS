//
//  MyPageFlow.swift
//  Archive
//
//  Created by hanwe on 2021/10/21.
//

import UIKit
import RxFlow

class MyPageFlow: Flow {
    
    private enum Constants {
        static let MyPageStoryBoardName = "MyPage"
        static let myPageNavigationTitle = "내정보"
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let onboardingStoryBoard = UIStoryboard(name: Constants.MyPageStoryBoardName, bundle: nil)
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .myPageIsRequired(let cnt):
            return navigationToMyPageScreen(cardCount: cnt)
        case .loginInfomationIsRequired:
            break
        case .withdrawalIsRequired:
            break
        default:
            return .none
        }
        return .none
    }
    
    private func navigationToMyPageScreen(cardCount: Int) -> FlowContributors {
        let model: MyPageModel = MyPageModel(cardCount: cardCount) // test
        let reactor = MyPageReactor(model: model)
        let myPageViewController: MyPageViewController = onboardingStoryBoard.instantiateViewController(identifier: MyPageViewController.identifier) { corder in
            return MyPageViewController(coder: corder, reactor: reactor)
        }
        myPageViewController.title = Constants.myPageNavigationTitle
        rootViewController.pushViewController(myPageViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: myPageViewController,
                                                 withNextStepper: reactor))
    }
}
