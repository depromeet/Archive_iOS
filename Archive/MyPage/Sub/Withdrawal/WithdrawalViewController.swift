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

class WithdrawalViewController: UIViewController, StoryboardView, ActivityIndicatorable {

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
        initUI()
        self.reactor?.action.onNext(.cardCnt)
    }
    
    init?(coder: NSCoder, reactor: WithdrawalReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: WithdrawalReactor) {
        reactor.state.map { $0.cardCnt }
        .asDriver(onErrorJustReturn: 100)
        .drive(onNext: { [weak self] cnt in
            let sumAttString = NSMutableAttributedString(string: String(format: "그동안 기록했던\n%d개의\n소중한 전시 기록들이\n전부 사라져요\n그래도 탈퇴하시겠어요?", cnt), attributes: [NSAttributedString.Key.font: UIFont.fonts(.subTitle), NSAttributedString.Key.foregroundColor: Gen.Colors.gray01.color])
            sumAttString.addAttributedStringInSpecificString(targetString: "\(cnt)", attr: [NSAttributedString.Key.font: UIFont.fonts(.header2), NSAttributedString.Key.foregroundColor: Gen.Colors.black.color])
            sumAttString.addAttributedStringInSpecificString(targetString: "그래도 탈퇴하시겠어요?", attr: [NSAttributedString.Key.font: UIFont.fonts(.body), NSAttributedString.Key.foregroundColor: Gen.Colors.black.color])
            self?.mainContentsLabel.attributedText = sumAttString
        })
        .disposed(by: self.disposeBag)
        
        self.withdrawalBtn.rx.tap
            .map { Reactor.Action.withrawal }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.stayBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isLoading }
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
        self.backgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.mainTitleLabel.font = .fonts(.header3)
        self.mainTitleLabel.textColor = Gen.Colors.gray01.color
        self.mainTitleLabel.text = "아카이브를 삭제하면?"
        
        self.withdrawalBtn.layer.cornerRadius = 8
        self.withdrawalBtn.layer.borderWidth = 1
        self.withdrawalBtn.layer.borderColor = Gen.Colors.black.color.cgColor
        self.withdrawalBtn.setBackgroundColor(Gen.Colors.white.color, for: .normal)
        self.withdrawalBtn.setBackgroundColor(Gen.Colors.white.color, for: .highlighted)
        self.withdrawalBtn.setTitleColor(Gen.Colors.black.color, for: .normal)
        self.withdrawalBtn.setTitleColor(Gen.Colors.black.color, for: .highlighted)
        self.withdrawalBtn.setTitle("탈퇴하기", for: .normal)
        self.withdrawalBtn.setTitle("탈퇴하기", for: .highlighted)
        self.withdrawalBtn.titleLabel?.font = .fonts(.button)
        
        self.stayBtn.layer.cornerRadius = 8
        self.stayBtn.setBackgroundColor(Gen.Colors.black.color, for: .normal)
        self.stayBtn.setBackgroundColor(Gen.Colors.black.color, for: .highlighted)
        self.stayBtn.setTitleColor(Gen.Colors.white.color, for: .normal)
        self.stayBtn.setTitleColor(Gen.Colors.white.color, for: .highlighted)
        self.stayBtn.setTitle("더 사용하기", for: .normal)
        self.stayBtn.setTitle("더 사용하기", for: .highlighted)
        self.stayBtn.titleLabel?.font = .fonts(.button)
    }
    
    // MARK: internal function
    
    // MARK: action

}
