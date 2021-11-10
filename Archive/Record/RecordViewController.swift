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
    @IBOutlet weak var mainContainerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: private property
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        return vc
    }()
    
    private var imageRecordViewController: ImageRecordViewControllerProtocol?
    private var contentsRecordViewController: ContentsRecordViewControllerProtocol?
    
    private lazy var subViewControllers: [UIViewController] = Array()
    
    private var originMainContainerViewBottomConstraint: CGFloat = 0
    
    private var confirmBtn: UIBarButtonItem?
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeSubViewControllers()
        setPageViewController()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init?(coder: NSCoder, reactor: RecordReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: RecordReactor) {
        reactor.state
            .map { $0.currentEmotion }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] emotion in
                guard let emotion = emotion else { return }
                self?.imageRecordViewController?.showTopView()
                self?.imageRecordViewController?.reactor?.action.onNext(.setEmotion(emotion))
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
        
        reactor.state
            .map { $0.thumbnailImage }
            .subscribe(onNext: { [weak self] image in
                guard let image = image else { return }
                self?.imageRecordViewController?.reactor?.action.onNext(.setThumbnailImage(image))
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.images }
            .subscribe(onNext: { [weak self] images in
                guard let images = images else { return }
                self?.imageRecordViewController?.reactor?.action.onNext(.setImages(images))
            })
            .disposed(by: self.disposeBag)
        
        reactor.isAllDataSetted
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSetted in
                if isSetted {
                    self?.setConfirmBtnColor(Gen.Colors.black.color)
                    self?.confirmBtn?.isEnabled = true
                } else {
                    self?.setConfirmBtnColor(Gen.Colors.gray04.color)
                    self?.confirmBtn?.isEnabled = false
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        makeConfirmBtn()
        self.confirmBtn?.isEnabled = false
    }
    
    private func makeSubViewControllers() {
        makeImageRecordViewController()
        makeContentsRecordViewController()
    }
    
    private func makeImageRecordViewController() {
        let model: ImageRecordModel = ImageRecordModel()
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        self.mainContainerViewBottomConstraint.constant = keyboardHeight
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.mainContainerViewBottomConstraint.constant = self.originMainContainerViewBottomConstraint
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func makeConfirmBtn() {
        self.confirmBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(confirmAction(_:)))
        setConfirmBtnColor(Gen.Colors.gray04.color)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.removeAll()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = confirmBtn
    }
    
    private func setConfirmBtnColor(_ color: UIColor) {
        self.confirmBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .normal)
        self.confirmBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .highlighted)
        self.confirmBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .disabled)
    }
    
    private func removeConfrimBtn() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.removeAll()
    }
    
    // MARK: internal function
    
    // MARK: action
    
    @objc private func confirmAction(_ sender: UIButton) {
        
    }

}

extension RecordViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        makeConfirmBtn()
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
    func settedImageInfos(infos: [ImageInfo]) {
        self.reactor?.action.onNext(.setImageInfos(infos))
    }
    
    func clickedEmotionSelectArea(currentEmotion: Emotion?) {
        self.imageRecordViewController?.hideTopView()
        self.reactor?.action.onNext(.moveToSelectEmotion(currentEmotion))
    }

    func clickedPhotoSeleteArea() {
        self.reactor?.action.onNext(.moveToPhotoSelet)
    }

    func clickedContentsArea() {
        self.pageViewController.moveToNextPage()
        self.contentsRecordViewController?.setEmotion(self.reactor?.currentState.currentEmotion)
        removePageViewControllerSwipeGesture()
    }
    
    func addMorePhoto() {
        self.reactor?.action.onNext(.moveToPhotoSelet)
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
