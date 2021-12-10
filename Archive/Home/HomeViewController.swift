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
            ticketCollectionView.dataSource = self
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
    }
    
    func bind(reactor: HomeReactor) {
        
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCollectionViewCell.identifier, for: indexPath) as? TicketCollectionViewCell
        
        return cell ?? UICollectionViewCell()
    }
}
