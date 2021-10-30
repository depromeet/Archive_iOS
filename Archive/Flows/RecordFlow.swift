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
    
    weak var recordViewController: RecordViewController?
    weak var editEmotionViewController: EmotionSelectViewController?
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .recordIsRequired:
            return navigationToRecordScreen()
        case .recordEmotionEditIsRequired:
            return navigationToEditEmotion()
        case .recordEmotionEditIsComplete(let emotion):
            dismissEditEmotion(emotion: emotion)
            return .none
        case .recordImageSelectIsRequired:
            return navigationToImageSelect()
        case .recordImageSelectIsComplete(let images):
            return .none
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
        self.recordViewController = recordViewController
        rootViewController.pushViewController(recordViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: recordViewController,
                                                 withNextStepper: reactor))
    }
    
    private func navigationToEditEmotion() -> FlowContributors {
        let model: EmotionSelectModel = EmotionSelectModel()
        let reactor = EmotionSelectReactor(model: model)
        let emotionSelectViewController: EmotionSelectViewController = recordStoryBoard.instantiateViewController(identifier: EmotionSelectViewController.identifier) { corder in
            return EmotionSelectViewController(coder: corder, reactor: reactor)
        }
        emotionSelectViewController.title = ""
        emotionSelectViewController.modalPresentationStyle = .overFullScreen
        self.editEmotionViewController = emotionSelectViewController
        rootViewController.present(emotionSelectViewController, animated: false, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: emotionSelectViewController,
                                                 withNextStepper: reactor))
    }
    
    private func dismissEditEmotion(emotion: Emotion) {
        self.editEmotionViewController?.dismiss(animated: false, completion: nil)
        self.recordViewController?.reactor?.action.onNext(.setEmotion(emotion))
    }
    
    private func navigationToImageSelect() -> FlowContributors {
        let model: ImageSelectModel = ImageSelectModel()
        let reactor = ImageSelectReactor(model: model)
        let imageSelectViewController: ImageSelectViewController = recordStoryBoard.instantiateViewController(identifier: ImageSelectViewController.identifier) { corder in
            return ImageSelectViewController(coder: corder, reactor: reactor)
        }
        imageSelectViewController.title = ""
        let navi: UINavigationController = UINavigationController(rootViewController: imageSelectViewController)
        navi.modalPresentationStyle = .fullScreen
        rootViewController.present(navi, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: imageSelectViewController,
                                                 withNextStepper: reactor))
    }
    
}
