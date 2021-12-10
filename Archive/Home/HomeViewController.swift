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

final class HomeViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    
    @IBOutlet var mainContainerView: UIView!
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
    }
    
    // MARK: internal function
    
    // MARK: action
    
    
    
    
    
}
