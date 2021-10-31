//
//  RecordViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import SnapKit


class RecordViewController: UIViewController, StoryboardView {

    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    
    // MARK: private property
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        return vc
    }()
    
    private var imageRecordViewController: ImageRecordViewControllerProtocol?
    private var contentsRecordViewController: ContentsRecordViewControllerProtocol?
    
    lazy var subViewControllers: [UIViewController] = Array()
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeSubViewControllers()
        setPageViewController()
        
        // 이하 테스트코드 todo 수정
        guard let imageRecordViewController = self.imageRecordViewController else { return }
        imageRecordViewController.delegate = self
        guard let contentsRecordViewController = self.contentsRecordViewController else { return }
        subViewControllers.append((imageRecordViewController as? UIViewController) ?? UIViewController())
        subViewControllers.append((contentsRecordViewController as? UIViewController) ?? UIViewController())
        contentsRecordViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.delegate = self
        if let firstVC = subViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        removePageViewControllerSwipeGesture()
    }
    
    init?(coder: NSCoder, reactor: RecordReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: RecordReactor) {
        reactor.state.map { $0.currentEmotion }
        .asDriver(onErrorJustReturn: nil)
        .drive(onNext: { [weak self] emotion in
            guard let emotion = emotion else { return }
            self?.imageRecordViewController?.showTopView()
            self?.imageRecordViewController?.setUICurrentEmotion(emotion)
        })
        .disposed(by: self.disposeBag)
        
        reactor.moveToConfig
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                CommonAlertView.shared.show(message: "티켓 기록 사진을 선택하려면 사진 라이브러리 접근권한이 필요합니다.", subMessage: nil, btnText: "확인", hapticType: .warning, confirmHandler: {
                    Util.moveToSetting()
                    CommonAlertView.shared.hide(nil)
                })
            })
            .disposed(by: self.disposeBag)
        
        reactor.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { errorMsg in
                CommonAlertView.shared.show(message: errorMsg, subMessage: nil, btnText: "확인", hapticType: .error, confirmHandler: {
                    CommonAlertView.shared.hide(nil)
                })
            })
            .disposed(by: self.disposeBag)
        
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
    }
    
    private func makeSubViewControllers() {
        makeImageRecordViewController()
        makeContentsRecordViewController()
    }
    
    private func makeImageRecordViewController() {
        let model: ImageRecordModel = ImageRecordModel(images: [])
        let reactor = ImageRecordReactor(model: model)
        let imageRecordViewController: ImageRecordViewController = UIStoryboard(name: "Record", bundle: nil).instantiateViewController(identifier: ImageRecordViewController.identifier) { corder in
            return ImageRecordViewController(coder: corder, reactor: reactor)
        }
        self.imageRecordViewController = imageRecordViewController
    }
    
    private func makeContentsRecordViewController() {
        let model: ContentsRecordModel = ContentsRecordModel()
        let reactor = ContentsRecordReactor(model: model)
        let contentsRecordViewController: ContentsRecordViewController = UIStoryboard(name: "Record", bundle: nil).instantiateViewController(identifier: ContentsRecordViewController.identifier) { corder in
            return ContentsRecordViewController(coder: corder, reactor: reactor)
        }
        self.contentsRecordViewController = contentsRecordViewController
    }
    
    private func setPageViewController() {
        addChild(pageViewController)
        self.mainContainerView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(self.mainContainerView)
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func removePageViewControllerSwipeGesture() {
        for view in self.pageViewController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    // MARK: internal function
    
    // MARK: action

}

extension RecordViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return subViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == subViewControllers.count {
            return nil
        }
        return subViewControllers[nextIndex]
    }
}


extension RecordViewController: ImageRecordViewControllerDelegate {
    func clickedEmotionSelectArea() {
        self.imageRecordViewController?.hideTopView()
        self.reactor?.action.onNext(.moveToSelectEmotion)
    }

    func clickedPhotoSeleteArea() {
        self.reactor?.action.onNext(.moveToPhotoSelet)
    }

    func clickedContentsArea() {
        self.pageViewController.moveToNextPage()
        self.contentsRecordViewController?.setEmotion(self.reactor?.currentState.currentEmotion)
        removePageViewControllerSwipeGesture()
    }
}

extension RecordViewController: ContentsRecordViewControllerDelegate {
    
    func moveToBeforeViewController() {
        self.pageViewController.moveToPreviousPage()
        removePageViewControllerSwipeGesture()
    }
    
    func completeContentsRecord(infoData: ContentsRecordModelData) {
        self.reactor?.action.onNext(.setRecordInfo(infoData))
        self.pageViewController.moveToPreviousPage()
        removePageViewControllerSwipeGesture()
        self.imageRecordViewController?.setRecordTitle(infoData.title)
    }
}
