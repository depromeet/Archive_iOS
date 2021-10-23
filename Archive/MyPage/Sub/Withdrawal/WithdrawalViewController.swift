//
//  WithdrawalViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

class WithdrawalViewController: UIViewController, StoryboardView {

    // MARK: IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainContentsLabel: UILabel!
    @IBOutlet weak var withdrawalBtn: UIButton!
    @IBOutlet weak var stayBtn: UIButton!
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIU()
    }
    
    init?(coder: NSCoder, reactor: WithdrawalReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: WithdrawalReactor) {
        
        
    }
    
    // MARK: private function
    
    private func initIU() {
        self.backgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
//        self.mainTitleLabel.font =
//        self.mainTitleLabel.textColor =
//        self.mainTitleLabel.text =
        
//        mainContentsLabel
        
//        self.withdrawalBtn.
//        self.stayBtn.
    }
    
    // MARK: internal function
    
    // MARK: action

}
