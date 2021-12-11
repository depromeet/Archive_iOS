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
        static let DetailStoryBoardName = "Detail"
        static let DetailNavigationTitle = "나의 아카이브"
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let homeStoryBoard = UIStoryboard(name: Constants.HomeStoryBoardName, bundle: nil)
    private let detailStoryBoard = UIStoryboard(name: Constants.DetailStoryBoardName, bundle: nil)
    private var subVCNavi: UINavigationController?
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .homeIsRequired:
            return navigationToHomeScreen()
        case .detailIsRequired(let info):
            return navigationToDetailScreen(infoData: info)
        default:
            return .none
        }
    }
    
    private func navigationToHomeScreen() -> FlowContributors {
        
        let reactor = HomeReactor()
        let homeViewController: HomeViewController = homeStoryBoard.instantiateViewController(identifier: HomeViewController.identifier) { corder in
            return HomeViewController(coder: corder, reactor: reactor)
        }
        homeViewController.title = Constants.HomeNavigationTitle
        rootViewController.pushViewController(homeViewController, animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: homeViewController, withNextStepper: reactor, allowStepWhenNotPresented: false, allowStepWhenDismissed: false))
    }
    
    private func navigationToDetailScreen(infoData: ArchiveDetailInfo) -> FlowContributors {
        let model: DetailModel = DetailModel(recordData: infoData)
        let reactor = DetailReactor(model: model)
        let detailViewController: DetailViewController = detailStoryBoard.instantiateViewController(identifier: DetailViewController.identifier) { corder in
            return DetailViewController(coder: corder, reactor: reactor)
        }
        detailViewController.title = Constants.DetailNavigationTitle
        DispatchQueue.main.async {
            self.subVCNavi = UINavigationController(rootViewController: detailViewController)
            if let navi = self.subVCNavi {
                navi.modalPresentationStyle = .fullScreen
                self.rootViewController.present(navi, animated: true, completion: nil)
            }
        }
        return .one(flowContributor: .contribute(withNextPresentable: detailViewController,
                                                 withNextStepper: reactor))
    }
    
}
