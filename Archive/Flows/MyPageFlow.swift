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
        static let MyPageNavigationTitle = "내정보"
        static let LoginInfoNavigationTitle = "로그인 정보"
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let myPageStoryBoard = UIStoryboard(name: Constants.MyPageStoryBoardName, bundle: nil)
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .myPageIsRequired(let cnt):
            return navigationToMyPageScreen(cardCount: cnt)
        case .loginInfomationIsRequired(let type):
            return navigationToLoginInformationScreen(type: type)
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
        let myPageViewController: MyPageViewController = myPageStoryBoard.instantiateViewController(identifier: MyPageViewController.identifier) { corder in
            return MyPageViewController(coder: corder, reactor: reactor)
        }
        myPageViewController.title = Constants.MyPageNavigationTitle
        rootViewController.pushViewController(myPageViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: myPageViewController,
                                                 withNextStepper: reactor))
    }
    
    private func navigationToLoginInformationScreen(type: LoginType) -> FlowContributors {
        let model: LoginInformationModel = LoginInformationModel(loginInfo: "")
        let reactor = LoginInformationReactor(model: model, type: type)
        let loginInfoViewController: LoginInformationViewController = myPageStoryBoard.instantiateViewController(identifier: LoginInformationViewController.identifier) { corder in
            return LoginInformationViewController(coder: corder, reactor: reactor)
        }
        loginInfoViewController.title = Constants.LoginInfoNavigationTitle
        rootViewController.pushViewController(loginInfoViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: loginInfoViewController, withNextStepper: reactor))
    }
}
