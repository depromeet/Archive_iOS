//
//  DetailStep.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit
import RxFlow

class DetailFlow: Flow {
    
    private enum Constants {
        static let DetailStoryBoardName = "Detail"
        static let DetailNavigationTitle = "테스트"
//        static let LoginInfoNavigationTitle = "로그인 정보"
//        static let WithdrawalNavigationTitle = "회원탈퇴"
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let storyBoard = UIStoryboard(name: Constants.DetailStoryBoardName, bundle: nil)
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .detailIsRequired(let detailData):
            return navigationToDetailScreen(infoData: detailData)
        default:
            return .none
        }
    }
    
    private func navigationToDetailScreen(infoData: RecordData) -> FlowContributors {
        let model: DetailModel = DetailModel(recordData: infoData)
        let reactor = DetailReactor(model: model)
        let detailViewController: DetailViewController = storyBoard.instantiateViewController(identifier: DetailViewController.identifier) { corder in
            return DetailViewController(coder: corder, reactor: reactor)
        }
        detailViewController.title = Constants.DetailNavigationTitle
        rootViewController.pushViewController(detailViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: detailViewController,
                                                 withNextStepper: reactor))
    }
    
}
