//
//  RecordUploadViewController.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Lottie

class RecordUploadViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var contetnsContainerView: UIView!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var lottieContainerView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.reactor?.action.onNext(.record)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animationView.play(completion: nil)
    }
    
    init?(coder: NSCoder, reactor: RecordUploadReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: RecordUploadReactor) {
        self.cancelBtn.rx
            .tap
            .subscribe(onNext: {
                self.animationView.stop()
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.recordIsDone }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isDone in
                if isDone {
                    self?.animationView.stop()
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    deinit {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        self.contetnsContainerView.backgroundColor = .clear
        
        self.contentsLabel.numberOfLines = 2
        self.contentsLabel.font = .fonts(.header2)
        self.contentsLabel.textColor = Gen.Colors.gray02.color
        self.contentsLabel.text = "아카이브를\n보관  중입니다."
        
        self.lottieContainerView.backgroundColor = .clear
        
        self.animationView.backgroundColor = .clear
        self.animationView.animation = Animation.named("uploadTmp")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.loopMode = .loop
    }
    
    // MARK: internal function
    
    // MARK: action

}
