//
//  MyPageViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/21.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

class MyPageViewController: UIViewController, StoryboardView {

    // Todo: StackView나 TableView로? 뷰로 했는데 셀 높이를 고정시켜서 글자가 개행되면 답이 없는걸..
    
    // MARK: IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var myCardCntTitleLabel: UILabel!
    @IBOutlet weak var myCardCntLabel: UILabel!
    @IBOutlet weak var loginInfomationTitleLabel: UILabel!
    @IBOutlet weak var loginInfomationBtn: UIButton!
    @IBOutlet weak var pushAgreeTitleLabel: UILabel!
    @IBOutlet weak var pushAgreeSwitch: UISwitch!
    @IBOutlet weak var pushAgreeContentsLabel: UILabel!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var termsTitleLabel: UILabel!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var privacyTitleLabel: UILabel!
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIU()
        self.reactor?.action.onNext(.cardCnt)
    }
    
    init?(coder: NSCoder, reactor: MyPageReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: MyPageReactor) {
        self.reactor?.state.map { $0.cardCnt }
        .asDriver(onErrorJustReturn: 100)
        .drive(onNext: { [weak self] cnt in
            print("cnt: \(cnt)")
            self?.myCardCntLabel.text = "\(cnt)"
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initIU() {
        self.backgroundView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        
        self.myCardCntTitleLabel.font = .fonts(.subTitle)
        self.myCardCntTitleLabel.textColor = Gen.Colors.gray02.color
        self.myCardCntTitleLabel.text = "내가 기록한 전시"
        
        self.myCardCntLabel.font = .fonts(.header2)
        self.myCardCntLabel.textColor = Gen.Colors.gray01.color
        
        self.loginInfomationTitleLabel.font = .fonts(.subTitle)
        self.loginInfomationTitleLabel.textColor = Gen.Colors.gray02.color
        self.loginInfomationTitleLabel.text = "로그인 정보"
        
        self.pushAgreeTitleLabel.font = .fonts(.subTitle)
        self.pushAgreeTitleLabel.textColor = Gen.Colors.gray02.color
        self.pushAgreeTitleLabel.text = "푸시 알림 허용"
        
        self.pushAgreeSwitch.tintColor = Gen.Colors.black.color
        
        self.pushAgreeContentsLabel.font = .fonts(.caption)
        self.pushAgreeContentsLabel.textColor = Gen.Colors.gray03.color
        self.pushAgreeContentsLabel.text = "전시회를 다녀오고, 시간이 지나면 알려드립니다."
        
        self.termsTitleLabel.font = .fonts(.subTitle)
        self.termsTitleLabel.textColor = Gen.Colors.gray02.color
        self.termsTitleLabel.text = "이용약관 보기"
        
        self.privacyTitleLabel.font = .fonts(.subTitle)
        self.privacyTitleLabel.textColor = Gen.Colors.gray02.color
        self.privacyTitleLabel.text = "개인정보 처리방침"
        
    }
    
    // MARK: internal function
    
    // MARK: action

}
