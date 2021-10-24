//
//  RecordFlow.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import RxFlow

class RecordFlow: Flow {
    private enum Constants {
        static let RecordStoryBoardName = "Record"
        static let RecordNavigationTitle = "전시기록"
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let recordStoryBoard = UIStoryboard(name: Constants.RecordStoryBoardName, bundle: nil)
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .recordIsRequired:
            return navigationToRecordScreen()
        default:
            return .none
        }
    }
    
    private func navigationToRecordScreen() -> FlowContributors {
        let model: RecordModel = RecordModel()
        let reactor = RecordReactor(model: model)
        let recordViewController: RecordViewController = recordStoryBoard.instantiateViewController(identifier: RecordViewController.identifier) { corder in
            return RecordViewController(coder: corder, reactor: reactor)
        }
        recordViewController.title = Constants.RecordNavigationTitle
        rootViewController.pushViewController(recordViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: recordViewController,
                                                 withNextStepper: reactor))
    }
    
}
