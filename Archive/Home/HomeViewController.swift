//
//  HomeViewController.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/30.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController, StoryboardView, ActivityIndicatorable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var contentsCountTitleLabel: UILabel!
    @IBOutlet weak var contentsCountLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addArchiveBtn: UIButton!
    @IBOutlet weak var emptyTicketImageView: UIImageView!
    @IBOutlet private weak var ticketCollectionView: UICollectionView! {
        didSet {
            let collectionViewLayout = TicketCollectionViewLayout(visibleItemsCount: 3,
                                                                  minimumScale: 0.8,
                                                                  horizontalInset: 32,
                                                                  spacing: 24)
            ticketCollectionView.collectionViewLayout = collectionViewLayout
            ticketCollectionView.delaysContentTouches = false
        }
    }
    
    // MARK: private property
    
    private let shimmerView: HomeShimmerView? = HomeShimmerView.instance()
    private var didScrollecDirection: Direction = .left
    
    // MARK: internal property
    
    var disposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    init?(coder: NSCoder, reactor: HomeReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.reactor?.action.onNext(.getMyArchives)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationItems() // TODO: 위치바꾸기
    }
    
    func bind(reactor: HomeReactor) {
        
        reactor.state.map { $0.archives }
        .distinctUntilChanged()
        .bind(to: self.ticketCollectionView.rx.items(cellIdentifier: TicketCollectionViewCell.identifier, cellType: TicketCollectionViewCell.self)) { index, element, cell in
            cell.infoData = element
        }
        .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.archives }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] in
                if $0.count == 0 {
                    self?.emptyTicketImageView.isHidden = false
                    self?.ticketCollectionView.isHidden = true
                } else {
                    self?.emptyTicketImageView.isHidden = true
                    self?.ticketCollectionView.isHidden = false
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.arvhivesCount }
        .distinctUntilChanged()
        .map { String("\($0)") }
        .bind(to: self.contentsCountLabel.rx.text)
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.arvhivesCount }
        .distinctUntilChanged()
        .bind(to: self.pageControl.rx.numberOfPages)
        .disposed(by: self.disposeBag)
        
        self.ticketCollectionView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] in
                guard let translation = self?.ticketCollectionView.panGestureRecognizer.translation(in: self?.ticketCollectionView.superview) else { return }
                if translation.x > 0 {
                    self?.didScrollecDirection = .left
                } else {
                    self?.didScrollecDirection = .right
                }
            })
            .disposed(by: self.disposeBag)
        
        self.ticketCollectionView.rx.didEndDisplayingCell
            .asDriver()
            .drive(onNext: { [weak self] info in
                guard let direction = self?.didScrollecDirection else { return }
                switch direction {
                case .right:
                    self?.pageControl.currentPage = info.at.item + 1
                case .left, .top, .bottom:
                    return
                }
            })
            .disposed(by: self.disposeBag)
        
        self.ticketCollectionView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { [weak self] info in
                guard let direction = self?.didScrollecDirection else { return }
                switch direction {
                case .left:
                    self?.pageControl.currentPage = info.at.item
                case .right, .top, .bottom:
                    return
                }
            })
            .disposed(by: self.disposeBag)
        
        self.ticketCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { info in
                reactor.action.onNext(.showDetail(info.item))
            })
            .disposed(by: self.disposeBag)
        
        self.addArchiveBtn.rx.tap
            .map { Reactor.Action.addArchive }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: false)
        .drive(onNext: { [weak self] in
            if $0 {
                self?.startIndicatorAnimating()
            } else {
                self?.stopIndicatorAnimating()
            }
        })
        .disposed(by: self.disposeBag)
        
//        reactor.state.map { $0.isShimmering } // 추후 업데이트 예정
//        .distinctUntilChanged()
//        .asDriver(onErrorJustReturn: false)
//        .drive(onNext: { [weak self] in
//            if $0 {
//                self?.shimmerView?.isHidden = false
//                self?.shimmerView?.startShimmering()
//            } else {
//                self?.shimmerView?.stopShimmering()
//                self?.shimmerView?.isHidden = true
//            }
//        })
//        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isShimmering } // 추후 업데이트 예정
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: false)
        .drive(onNext: { [weak self] in
            if $0 {
                self?.startIndicatorAnimating()
            } else {
                self?.stopIndicatorAnimating()
            }
        })
        .disposed(by: self.disposeBag)
        
    }
    
    // MARK: private function
    
    private func initUI() {
        if let shimmerView = self.shimmerView {
            self.mainContainerView.addSubview(shimmerView)
            shimmerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            shimmerView.isHidden = true
        }
        self.contentsCountTitleLabel.font = .fonts(.subTitle)
        self.contentsCountTitleLabel.textColor = Gen.Colors.black.color
        self.contentsCountTitleLabel.text = "기록한 전시"
        self.contentsCountLabel.font = .fonts(.header3)
        self.contentsCountLabel.textColor = Gen.Colors.black.color
        self.pageControl.pageIndicatorTintColor = Gen.Colors.gray03.color
        self.pageControl.currentPageIndicatorTintColor = Gen.Colors.gray01.color
    }
    
    private func makeNavigationItems() {
        let logoImage = Gen.Images.logo.image
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: -40, y: 0, width: 98, height: 18)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        
        let backImage = Gen.Images.iconMyPage.image // iconmypage
        backImage.withRenderingMode(.alwaysTemplate)
        let backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(myPageAction(_:)))
        self.navigationItem.rightBarButtonItem = backBarButtonItem
    }
    
    @objc private func myPageAction(_ sender: UIButton) {
        self.reactor?.action.onNext(.showMyPage(self.reactor?.currentState.arvhivesCount ?? 0))
    }
    
    // MARK: internal function
    
    func willDeletedIndex(_ index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let reactor = self?.reactor else {
                return
            }
            if index+1 >= reactor.currentState.archives.count {
                self?.ticketCollectionView.scrollToItem(at: IndexPath(item: index-1, section: 0), at: .top, animated: false)
            }
        }
    }
    
    // MARK: action
    
    
    
    
    
}
