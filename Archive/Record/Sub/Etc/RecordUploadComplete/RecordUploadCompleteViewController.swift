//
//  RecordUploadCompleteViewController.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class RecordUploadCompleteViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var instagramShareBtn: UIButton!
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: RecordUploadCompleteReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: RecordUploadCompleteReactor) {
        
    }
    
    deinit {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        
        self.mainContainerView.backgroundColor = .clear
        
        self.titleLabel.font = .fonts(.header2)
        self.titleLabel.textColor = Gen.Colors.black.color
        self.titleLabel.text = "나만보기\n아쉬운 전시라면?"
        
        self.shareLabel.font = .fonts(.subTitle)
        self.shareLabel.textColor = Gen.Colors.black.color
        self.shareLabel.text = "아카이브를 공유해보세요."
        
        
    }
    
    // MARK: internal function
    
    // MARK: action

}
