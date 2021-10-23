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
        static let WithdrawalNavigationTitle = "회원탈퇴"
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
        case .loginInfomationIsRequired(let type, let cardCnt):
            return navigationToLoginInformationScreen(type: type, cardCnt: cardCnt)
        case .withdrawalIsRequired(let cnt):
            return navigationToWithdrawalScreen(cardCount: cnt)
        default:
            return .none
        }
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
    
    private func navigationToLoginInformationScreen(type: LoginType, cardCnt: Int) -> FlowContributors {
        let model: LoginInformationModel = LoginInformationModel(loginInfo: "", cardCount: cardCnt)
        let reactor = LoginInformationReactor(model: model, type: type)
        let loginInfoViewController: LoginInformationViewController = myPageStoryBoard.instantiateViewController(identifier: LoginInformationViewController.identifier) { corder in
            return LoginInformationViewController(coder: corder, reactor: reactor)
        }
        loginInfoViewController.title = Constants.LoginInfoNavigationTitle
        rootViewController.pushViewController(loginInfoViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: loginInfoViewController, withNextStepper: reactor))
    }
    
    private func navigationToWithdrawalScreen(cardCount: Int) -> FlowContributors {
        let model: WithdrawalModel = WithdrawalModel(cardCount: cardCount)
        let reactor = WithdrawalReactor(model: model)
        let withdrawalViewController: WithdrawalViewController = myPageStoryBoard.instantiateViewController(identifier: WithdrawalViewController.identifier) { corder in
            return WithdrawalViewController(coder: corder, reactor: reactor)
        }
        withdrawalViewController.title = Constants.WithdrawalNavigationTitle
        rootViewController.pushViewController(withdrawalViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: withdrawalViewController, withNextStepper: reactor))
    }
}
