//
//  EmotionSelectViewController.swift
//  Archive
//
//  Created by hanwe lee on 2021/10/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EmotionSelectViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    @IBOutlet weak var baseContainerView: UIView!
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var bottomPaddingView: UIView!
    @IBOutlet weak var mainContentsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var preImageView: UIImageView!
    
    @IBOutlet weak var pleasantBtn: UIButton!
    @IBOutlet weak var funBtn: UIButton!
    @IBOutlet weak var splendidBtn: UIButton!
    @IBOutlet weak var wonderfulBtn: UIButton!
    @IBOutlet weak var impressiveBtn: UIButton!
    
    @IBOutlet weak var pleasantImageView: UIImageView!
    @IBOutlet weak var funImageView: UIImageView!
    @IBOutlet weak var splendidImageView: UIImageView!
    @IBOutlet weak var wonderfulImageView: UIImageView!
    @IBOutlet weak var impressiveImageView: UIImageView!
    
    @IBOutlet weak var pleasantLabel: UILabel!
    @IBOutlet weak var funLabel: UILabel!
    @IBOutlet weak var splendidLabel: UILabel!
    @IBOutlet weak var wonderfulLabel: UILabel!
    @IBOutlet weak var impressiveLabel: UILabel!
    
    @IBOutlet weak var helpLabel: UILabel!
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: EmotionSelectReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: EmotionSelectReactor) {
        self.pleasantBtn.rx.tap
            .map { Reactor.Action.select(.pleasant) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.funBtn.rx.tap
            .map { Reactor.Action.select(.fun) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.splendidBtn.rx.tap
            .map { Reactor.Action.select(.splendid) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.wonderfulBtn.rx.tap
            .map { Reactor.Action.select(.wonderful) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.impressiveBtn.rx.tap
            .map { Reactor.Action.select(.impressive) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.currentEmotion }
            .asDriver(onErrorJustReturn: .pleasant)
            .drive(onNext: { [weak self] emotion in
                self?.refreshUIForEmotion(emotion)
            })
            .disposed(by: self.disposeBag)
        
        self.completeBtn.rx.tap
            .map { Reactor.Action.completeEmotionEdit }
            .bind(to: reactor.action )
            .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.dim.color
        self.mainContentsView.backgroundColor = .clear
        self.bottomPaddingView.backgroundColor = Gen.Colors.white.color
        self.bottomView.backgroundColor = Gen.Colors.white.color
        self.titleLabel.font = .fonts(.header3)
        self.titleLabel.textColor = Gen.Colors.gray01.color
        self.titleLabel.text = "전시가 어땠나요?"
        
        self.completeBtn.titleLabel?.font = .fonts(.button)
        self.completeBtn.setTitle("완료", for: .normal)
        self.completeBtn.setTitle("완료", for: .highlighted)
        
        self.completeBtn.setTitleColor(Gen.Colors.black.color, for: .normal)
        self.completeBtn.setTitleColor(Gen.Colors.black.color, for: .highlighted)
        
        self.contentsLabel.font = .fonts(.body)
        self.contentsLabel.textColor = Gen.Colors.gray02.color
        self.contentsLabel.text = "선택한 감정으로 티켓커버가 변경됩니다."
        
        self.pleasantLabel.font = .fonts(.body)
        self.pleasantLabel.text = "기분좋은"
        self.funLabel.font = .fonts(.body)
        self.funLabel.text = "재미있는"
        self.splendidLabel.font = .fonts(.body)
        self.splendidLabel.text = "아름다운"
        self.wonderfulLabel.font = .fonts(.body)
        self.wonderfulLabel.text = "경이로운"
        self.impressiveLabel.font = .fonts(.body)
        self.impressiveLabel.text = "인상적인"
        
        self.helpLabel.font = .fonts(.subTitle)
        self.helpLabel.textColor = Gen.Colors.gray03.color
        self.helpLabel.text = "이 영역에\n이미지가 표시됩니다."
    }
    
    private func refreshUIForEmotion(_ emotion: Emotion) {
        self.pleasantImageView.image = Gen.Images.typePleasantNo.image
        self.funImageView.image = Gen.Images.typeFunNo.image
        self.splendidImageView.image = Gen.Images.typeSplendidNo.image
        self.wonderfulImageView.image = Gen.Images.typeWonderfulNo.image
        self.impressiveImageView.image = Gen.Images.typeImpressiveNo.image
        self.pleasantLabel.textColor = Gen.Colors.gray03.color
        self.funLabel.textColor = Gen.Colors.gray03.color
        self.splendidLabel.textColor = Gen.Colors.gray03.color
        self.wonderfulLabel.textColor = Gen.Colors.gray03.color
        self.impressiveLabel.textColor = Gen.Colors.gray03.color
        switch emotion {
        case .fun:
            self.funImageView.image = Gen.Images.typeFun.image
            self.preImageView.image = Gen.Images.preFun.image
            self.funLabel.textColor = Gen.Colors.black.color
        case .impressive:
            self.impressiveImageView.image = Gen.Images.typeImpressive.image
            self.preImageView.image = Gen.Images.preImpressive.image
            self.impressiveLabel.textColor = Gen.Colors.black.color
        case .pleasant:
            self.pleasantImageView.image = Gen.Images.typePleasant.image
            self.preImageView.image = Gen.Images.prePleasant.image
            self.pleasantLabel.textColor = Gen.Colors.black.color
        case .splendid:
            self.splendidImageView.image = Gen.Images.typeSplendid.image
            self.preImageView.image = Gen.Images.preSplendid.image
            self.splendidLabel.textColor = Gen.Colors.black.color
        case .wonderful:
            self.wonderfulImageView.image = Gen.Images.typeWonderful.image
            self.preImageView.image = Gen.Images.preWonderful.image
            self.wonderfulLabel.textColor = Gen.Colors.black.color
        }
    }
    
    // MARK: internal function
    
    func fadeInAnimation() {
        self.baseContainerView.fadeIn(duration: 0.25, completeHandler: nil)
    }
    
    // MARK: action

}
