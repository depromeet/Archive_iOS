//
//  DetailViewController.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomContainerCiew: UIView!
    @IBOutlet weak var archiveTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
   
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: DetailReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: DetailReactor) {
        
    }
    
    deinit {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        
//        self.mainContainerView.backgroundColor =
//
//        @IBOutlet weak var topContainerView: UIView!
//        @IBOutlet weak var collectionView: UICollectionView!
//
//        @IBOutlet weak var bottomContainerCiew: UIView!
//        @IBOutlet weak var archiveTitleLabel: UILabel!
//        @IBOutlet weak var dateLabel: UILabel!
//
//        @IBOutlet weak var pageControl: UIPageControl!
    }
    
    // MARK: internal function
    
    // MARK: action

}
