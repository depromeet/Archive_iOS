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
    
    func bind(reactor: HomeReactor) {
        
        reactor.state.map { $0.archives }
        .distinctUntilChanged()
        .bind(to: self.ticketCollectionView.rx.items(cellIdentifier: TicketCollectionViewCell.identifier, cellType: TicketCollectionViewCell.self)) { index, element, cell in
            cell.infoData = element
        }
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
        
        self.ticketCollectionView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { [weak self] info in
                self?.pageControl.currentPage = info.at.item
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
        
        reactor.state.map { $0.isShimmering }
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: false)
        .drive(onNext: { [weak self] in
            if $0 {
                self?.shimmerView?.isHidden = false
                self?.shimmerView?.startShimmering()
            } else {
                self?.shimmerView?.stopShimmering()
                self?.shimmerView?.isHidden = true
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
    }
    
    // MARK: internal function
    
    // MARK: action
    
    
    
    
    
}
