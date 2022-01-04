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
        static let HomeNavigationTitle = ""
        static let DetailStoryBoardName = "Detail"
        static let DetailNavigationTitle = "나의 아카이브"
        static let MyPageStoryBoardName = "MyPage"
        static let MyPageNavigationTitle = "내정보"
        static let LoginInfoNavigationTitle = "로그인 정보"
        static let WithdrawalNavigationTitle = "회원탈퇴"
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
    
    private let homeStoryBoard = UIStoryboard(name: Constants.HomeStoryBoardName, bundle: nil)
    private let detailStoryBoard = UIStoryboard(name: Constants.DetailStoryBoardName, bundle: nil)
    private let myPageStoryBoard = UIStoryboard(name: Constants.MyPageStoryBoardName, bundle: nil)
    private let recordStoryBoard = UIStoryboard(name: Constants.RecordStoryBoardName, bundle: nil)
    
    private var subVCNavi: UINavigationController?
    private weak var homeViewControllerPtr: HomeViewController?
    private weak var recordViewController: RecordViewController?
    private weak var editEmotionViewController: EmotionSelectViewController?
    private weak var imageSelectViewControllerNavi: UINavigationController?
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }
        switch step {
        case .homeIsRequired:
            return navigationToHomeScreen()
        case .detailIsRequired(let info, let index):
            return navigationToDetailScreen(infoData: info, index: index)
        case .myPageIsRequired(let cnt):
            return navigationToMyPageScreen(cardCount: cnt)
        case .loginInfomationIsRequired(let type, let email, let cardCnt):
            return navigationToLoginInformationScreen(type: type, eMail: email ?? "", cardCnt: cardCnt)
        case .withdrawalIsRequired(let cnt):
            return navigationToWithdrawalScreen(cardCount: cnt)
        case .logout:
            return .end(forwardToParentFlowWithStep: ArchiveStep.logout)
        case .recordIsRequired:
            return navigationToRecordScreen()
        case .recordEmotionEditIsRequired(let emotion):
            return navigationToEditEmotion(currentEmotion: emotion)
        case .recordEmotionEditIsComplete(let emotion):
            dismissEditEmotion(emotion: emotion)
            return .none
        case .recordImageSelectIsRequired(let emotion):
            return navigationToImageSelect(emotion: emotion)
        case .recordImageSelectIsComplete(let thumbnailImage, let images):
            self.recordViewController?.reactor?.action.onNext(.setImages(images))
            self.recordViewController?.reactor?.action.onNext(.setThumbnailImage(thumbnailImage))
            dismissImageSelect()
            return .none
        case .recordUploadIsRequired(let contents, let thumbnail, let emotion, let imageInfos):
            return navigationToRecordUpload(contents: contents, thumbnail: thumbnail, emotion: emotion, imageInfos: imageInfos)
        case .recordUploadIsComplete(let thumbnail, let emotion, let contentsInfo):
            rootViewController.dismiss(animated: false, completion: nil)
            return navigationToRecordUploadComplete(thumbnail: thumbnail, emotion: emotion, conetentsInfo: contentsInfo)
        case .recordComplete:
            rootViewController.dismiss(animated: true, completion: { [weak self] in
                self?.rootViewController.popToRootViewController(animated: false)
                self?.homeViewControllerPtr?.reactor?.action.onNext(.getMyArchives)
                self?.homeViewControllerPtr?.moveCollectionViewFirstIndex()
            })
            return .none
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
        self.homeViewControllerPtr = homeViewController
        rootViewController.pushViewController(homeViewController, animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: homeViewController, withNextStepper: reactor, allowStepWhenNotPresented: false, allowStepWhenDismissed: false))
    }
    
    private func navigationToDetailScreen(infoData: ArchiveDetailInfo, index: Int) -> FlowContributors {
        let model: DetailModel = DetailModel(recordData: infoData, index: index)
        let reactor = DetailReactor(model: model)
        let detailViewController: DetailViewController = detailStoryBoard.instantiateViewController(identifier: DetailViewController.identifier) { corder in
            return DetailViewController(coder: corder, reactor: reactor)
        }
        detailViewController.title = Constants.DetailNavigationTitle
        detailViewController.delegate = self
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
    
    private func navigationToMyPageScreen(cardCount: Int) -> FlowContributors {
        let model: MyPageModel = MyPageModel(cardCount: cardCount)
        let reactor = MyPageReactor(model: model)
        let myPageViewController: MyPageViewController = myPageStoryBoard.instantiateViewController(identifier: MyPageViewController.identifier) { corder in
            return MyPageViewController(coder: corder, reactor: reactor)
        }
        myPageViewController.title = Constants.MyPageNavigationTitle
        rootViewController.pushViewController(myPageViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: myPageViewController,
                                                 withNextStepper: reactor))
    }
    
    private func navigationToLoginInformationScreen(type: LoginType, eMail: String, cardCnt: Int) -> FlowContributors {
        let model: LoginInformationModel = LoginInformationModel(email: eMail, cardCount: cardCnt)
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
    
    private func navigationToRecordScreen() -> FlowContributors {
        let model: RecordModel = RecordModel()
        let reactor = RecordReactor(model: model)
        let recordViewController: RecordViewController = recordStoryBoard.instantiateViewController(identifier: RecordViewController.identifier) { corder in
            return RecordViewController(coder: corder, reactor: reactor)
        }
        recordViewController.title = Constants.RecordNavigationTitle
        self.recordViewController = recordViewController
        rootViewController.pushViewController(recordViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: recordViewController,
                                                 withNextStepper: reactor))
    }
    
    private func navigationToEditEmotion(currentEmotion: Emotion?) -> FlowContributors {
        let model: EmotionSelectModel = EmotionSelectModel()
        let reactor = EmotionSelectReactor(model: model, currentEmotion: currentEmotion)
        let emotionSelectViewController: EmotionSelectViewController = recordStoryBoard.instantiateViewController(identifier: EmotionSelectViewController.identifier) { corder in
            return EmotionSelectViewController(coder: corder, reactor: reactor)
        }
        emotionSelectViewController.title = ""
        emotionSelectViewController.modalPresentationStyle = .overFullScreen
        self.editEmotionViewController = emotionSelectViewController
        rootViewController.present(emotionSelectViewController, animated: false, completion: {
            emotionSelectViewController.fadeInAnimation()
        })
        return .one(flowContributor: .contribute(withNextPresentable: emotionSelectViewController,
                                                 withNextStepper: reactor))
    }
    
    private func dismissEditEmotion(emotion: Emotion) {
        self.editEmotionViewController?.dismiss(animated: false, completion: nil)
        self.recordViewController?.reactor?.action.onNext(.setEmotion(emotion))
    }
    
    private func navigationToImageSelect(emotion: Emotion) -> FlowContributors {
        let model: ImageSelectModel = ImageSelectModel()
        let reactor = ImageSelectReactor(model: model, emotion: emotion)
        let imageSelectViewController: ImageSelectViewController = recordStoryBoard.instantiateViewController(identifier: ImageSelectViewController.identifier) { corder in
            return ImageSelectViewController(coder: corder, reactor: reactor)
        }
        imageSelectViewController.title = ""
        let navi: UINavigationController = UINavigationController(rootViewController: imageSelectViewController)
        navi.modalPresentationStyle = .fullScreen
        self.imageSelectViewControllerNavi = navi
        rootViewController.present(navi, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: imageSelectViewController,
                                                 withNextStepper: reactor))
    }
    
    private func dismissImageSelect() {
        self.imageSelectViewControllerNavi?.dismiss(animated: true, completion: {
            self.imageSelectViewControllerNavi?.viewControllers = []
        })
    }
    
    private func navigationToRecordUpload(contents: ContentsRecordModelData, thumbnail: UIImage, emotion: Emotion, imageInfos: [ImageInfo]?) -> FlowContributors {
        let model: RecordUploadModel = RecordUploadModel(contents: contents, thumbnailImage: thumbnail, emotion: emotion, imageInfos: imageInfos)
        let reactor = RecordUploadReactor(model: model)
        let recordUploadViewController: RecordUploadViewController = recordStoryBoard.instantiateViewController(identifier: RecordUploadViewController.identifier) { corder in
            return RecordUploadViewController(coder: corder, reactor: reactor)
        }
        recordUploadViewController.modalPresentationStyle = .fullScreen
        rootViewController.present(recordUploadViewController, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: recordUploadViewController,
                                                 withNextStepper: reactor))
    }
    
    private func navigationToRecordUploadComplete(thumbnail: UIImage, emotion: Emotion, conetentsInfo: ContentsRecordModelData) -> FlowContributors {
        let model: RecordUploadCompleteModel = RecordUploadCompleteModel(thumbnail: thumbnail, emotion: emotion, contentsInfo: conetentsInfo)
        let reactor = RecordUploadCompleteReactor(model: model)
        let recordUploadCompleteViewController: RecordUploadCompleteViewController = recordStoryBoard.instantiateViewController(identifier: RecordUploadCompleteViewController.identifier) { corder in
            return RecordUploadCompleteViewController(coder: corder, reactor: reactor)
        }
        recordUploadCompleteViewController.modalPresentationStyle = .fullScreen
        rootViewController.present(recordUploadCompleteViewController, animated: false, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: recordUploadCompleteViewController,
                                                 withNextStepper: reactor))
    }
    
}

extension HomeFlow: CommonViewControllerProtocol, DetailViewControllerDelegate {
    func willDeletedArchive(index: Int) {
        self.homeViewControllerPtr?.willDeletedIndex(index)
    }
    
    func deletedArchive() {
        self.homeViewControllerPtr?.reactor?.action.onNext(.getMyArchives)
    }
    
    func closed(from: UIViewController) {
        self.subVCNavi?.viewControllers = []
        self.subVCNavi = nil
    }
}
