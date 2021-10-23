//
//  LoginInformationViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

class LoginInformationViewController: UIViewController, StoryboardView {

    // MARK: IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollViewContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var eMailLabel: UILabel!
    @IBOutlet weak var eMailTextContainerView: UIView!
    @IBOutlet weak var eMailIconImageView: UIImageView!
    @IBOutlet weak var eMailIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentPWLabel: UILabel!
    @IBOutlet weak var currentPWTextContainerView: UIView!
    @IBOutlet weak var currentPWTextField: UITextField!
    @IBOutlet weak var passwordCorrectLabel: UILabel!
    @IBOutlet weak var passwordCorrectImageView: UIImageView!
    @IBOutlet weak var newPWLabel: UILabel!
    @IBOutlet weak var newPWTextContainerView: UIView!
    @IBOutlet weak var newPWTextField: UITextField!
    @IBOutlet weak var newPWEngCorrectLabel: UILabel!
    @IBOutlet weak var newPWEngCorrectImageView: UIImageView!
    @IBOutlet weak var newPWNumCorrectLabel: UILabel!
    @IBOutlet weak var newPWNumCorrectImageView: UIImageView!
    @IBOutlet weak var newPWSizeCorrectLabel: UILabel!
    @IBOutlet weak var newPWSizeCorrectImageView: UIImageView!
    @IBOutlet weak var confirmBtnView: UIView!
    @IBOutlet weak var confirmBtnTitleLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var withdrawalLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    
    // MARK: private property
    
    private var originEMailIconWidthConstraint: CGFloat = 0
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIU()
        self.reactor?.action.onNext(.refreshLoginType)
    }
    
    init?(coder: NSCoder, reactor: LoginInformationReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: LoginInformationReactor) {
        self.reactor?.state.map { $0.type }
        .asDriver(onErrorJustReturn: .eMail)
        .drive(onNext: { [weak self] type in
            switch type {
            case .eMail:
                self?.refreshUIForEMail()
            case .kakao:
                self?.refreshUIForKakao()
            case .apple:
                self?.refreshUIForApple()
            }
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initIU() {
        self.backgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollViewContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.eMailLabel.font = .fonts(.body)
        self.eMailLabel.textColor = Gen.Colors.gray01.color
        self.eMailLabel.text = "이메일"
        self.eMailTextContainerView.layer.cornerRadius = 8
        self.eMailTextContainerView.layer.borderColor = Gen.Colors.gray04.color.cgColor
        self.eMailTextContainerView.layer.borderWidth = 1
        self.originEMailIconWidthConstraint = self.eMailIconWidthConstraint.constant
        self.eMailLabel.font = .fonts(.body)
        self.currentPWLabel.font = .fonts(.body)
        self.currentPWLabel.textColor = Gen.Colors.gray01.color
        self.currentPWLabel.text = "현재 비밀번호"
        self.currentPWTextContainerView.layer.cornerRadius = 8
        self.currentPWTextContainerView.layer.borderColor = Gen.Colors.gray04.color.cgColor
        self.currentPWTextContainerView.layer.borderWidth = 1
//        self.currentPWTextField.placeholder.font = .fonts(.body)
//        self.currentPWTextField.placeholder.textColor = Gen.Colors.gray04.color
        self.currentPWTextField.textColor = Gen.Colors.black.color
        self.passwordCorrectLabel.font = .fonts(.body)
        self.passwordCorrectLabel.text = "비밀번호 일치"
        self.currentPWLabel.font = .fonts(.body)
        self.currentPWLabel.textColor = Gen.Colors.black.color
        self.currentPWLabel.text = "현재 비밀번호"
        self.newPWLabel.font = .fonts(.body)
        self.newPWLabel.textColor = Gen.Colors.gray01.color
        self.newPWLabel.text = "신규 비밀번호"
        self.newPWTextContainerView.layer.cornerRadius = 8
        self.newPWTextContainerView.layer.borderColor = Gen.Colors.gray04.color.cgColor
        self.newPWTextContainerView.layer.borderWidth = 1
//        self.newPWTextField.placeholder.font = .fonts(.body)
//        self.newPWTextField.placeholder.textColor = Gen.Colors.gray04.color
        self.newPWTextField.textColor = Gen.Colors.black.color
        self.newPWEngCorrectLabel.font = .fonts(.body)
        self.newPWEngCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWEngCorrectLabel.text = "영문조합"
        self.newPWNumCorrectLabel.font = .fonts(.body)
        self.newPWNumCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWNumCorrectLabel.text = "숫자조합"
        self.newPWSizeCorrectLabel.font = .fonts(.body)
        self.newPWSizeCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWSizeCorrectLabel.text = "8-20자 이내"
        self.confirmBtnView.layer.cornerRadius = 8
        self.confirmBtnTitleLabel.font = .fonts(.button)
        self.confirmBtnTitleLabel.text = "비밀번호 변경"
        self.withdrawalLabel.font = .fonts(.body)
        self.withdrawalLabel.textColor = Gen.Colors.gray04.color
        self.withdrawalLabel.text = "회원탈퇴"
        self.withdrawalLabel.isUserInteractionEnabled = true
        self.logOutLabel.font = .fonts(.body)
        self.logOutLabel.textColor = Gen.Colors.gray04.color
        self.logOutLabel.text = "로그아웃"
        self.logOutLabel.isUserInteractionEnabled = true
    }
    
    private func refreshUIForEMail() {
        
    }
    
    private func refreshUIForKakao() {
        
    }
    
    private func refreshUIForApple() {
        
    }
    
    // MARK: internal function
    
    // MARK: action

}
