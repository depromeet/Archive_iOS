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
    @IBOutlet weak var scrollContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var eMailTitleLabel: UILabel!
    @IBOutlet weak var eMailTextContainerView: UIView!
    @IBOutlet weak var eMailLabel: UILabel!
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
    @IBOutlet weak var withdrawalBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    // MARK: private property
    
    private var originEMailIconWidthConstraint: CGFloat = 0
    private var originScrollContainerViewBottomConstraint: CGFloat = 0
    
    private lazy var activePlaceHolderAttributes = [
        NSAttributedString.Key.foregroundColor: Gen.Colors.gray03.color,
        NSAttributedString.Key.font: UIFont.fonts(.body)
    ]
    
    private lazy var nonActivePlaceHolderAttributes = [
        NSAttributedString.Key.foregroundColor: Gen.Colors.gray04.color,
        NSAttributedString.Key.font: UIFont.fonts(.body)
    ]
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.reactor?.action.onNext(.refreshLoginType)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        self.reactor?.action.onNext(.getEmail)
    }
    
    init?(coder: NSCoder, reactor: LoginInformationReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: LoginInformationReactor) {
        reactor.state.map { $0.type }
        .asDriver(onErrorJustReturn: .kakao)
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
        
        self.withdrawalBtn.rx.tap
            .map { Reactor.Action.moveWithdrawalPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.logoutBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                CommonAlertView.shared.show(message: "로그아웃 하시겠어요?", subMessage: "로그인을 한 상태에서만\n나의 티켓들을 볼 수 있어요.", confirmBtnTxt: "로그아웃", cancelBtnTxt: "취소", confirmHandler: {
                    CommonAlertView.shared.hide(nil)
                    reactor.action.onNext(.logout)
                }, cancelHandler: {
                    CommonAlertView.shared.hide(nil)
                })
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.eMail }
        .bind(to: self.eMailLabel.rx.text)
        .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initUI() {
        self.backgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollViewContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.eMailTitleLabel.font = .fonts(.body)
        self.eMailTitleLabel.textColor = Gen.Colors.gray01.color
        self.eMailTitleLabel.text = "이메일"
        self.eMailTextContainerView.layer.cornerRadius = 8
        self.eMailTextContainerView.layer.borderColor = Gen.Colors.gray04.color.cgColor
        self.eMailTextContainerView.layer.borderWidth = 1
        self.eMailLabel.font = .fonts(.body)
        self.eMailLabel.textColor = Gen.Colors.black.color
        self.originEMailIconWidthConstraint = self.eMailIconWidthConstraint.constant
        self.eMailLabel.font = .fonts(.body)
        self.currentPWLabel.font = .fonts(.body)
        self.currentPWLabel.textColor = Gen.Colors.gray01.color
        self.currentPWLabel.text = "현재 비밀번호"
        self.currentPWTextContainerView.layer.cornerRadius = 8
        self.currentPWTextContainerView.layer.borderColor = Gen.Colors.gray04.color.cgColor
        self.currentPWTextContainerView.layer.borderWidth = 1
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
        self.withdrawalBtn.setTitle("회원탈퇴", for: .normal)
        self.withdrawalBtn.setTitleColor(Gen.Colors.gray04.color, for: .normal)
        self.withdrawalBtn.setTitle("회원탈퇴", for: .highlighted)
        self.withdrawalBtn.setTitleColor(Gen.Colors.gray04.color, for: .highlighted)
        self.withdrawalBtn.titleLabel?.font = .fonts(.body)
        self.logoutBtn.setTitle("로그아웃", for: .normal)
        self.logoutBtn.setTitleColor(Gen.Colors.gray04.color, for: .normal)
        self.logoutBtn.setTitle("로그아웃", for: .highlighted)
        self.logoutBtn.setTitleColor(Gen.Colors.gray04.color, for: .highlighted)
        self.logoutBtn.titleLabel?.font = .fonts(.body)
        self.currentPWTextField.returnKeyType = .done
        self.newPWTextField.returnKeyType = .done
    }
    
    private func refreshUIForEMail() {
        self.eMailIconWidthConstraint.constant = 0
        self.eMailIconImageView.isHidden = true
        self.eMailLabel.textColor = Gen.Colors.gray04.color
        self.eMailTextContainerView.backgroundColor = Gen.Colors.gray06.color
        self.passwordCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWEngCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWNumCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWSizeCorrectLabel.textColor = Gen.Colors.gray04.color
        self.confirmBtnView.backgroundColor = Gen.Colors.gray04.color
        self.confirmBtnTitleLabel.textColor = Gen.Colors.white.color
        self.currentPWTextContainerView.backgroundColor = Gen.Colors.white.color
        self.newPWTextContainerView.backgroundColor = Gen.Colors.white.color
        self.newPWTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요.", attributes: self.activePlaceHolderAttributes)
        self.currentPWTextField.attributedPlaceholder = NSAttributedString(string: "현재 비밀번호를 입력해주세요.", attributes: self.activePlaceHolderAttributes)
        self.newPWTextField.isEnabled = true
        self.currentPWTextField.isEnabled = true
    }
    
    private func refreshUIForKakao() {
        refreshUIForSocialLogin()
        self.eMailIconImageView.image = Gen.Images.kakaotalk.image
    }
    
    private func refreshUIForApple() {
        refreshUIForSocialLogin()
        self.eMailIconImageView.image = Gen.Images.btnApple.image
    }
    
    private func refreshUIForSocialLogin() {
        self.eMailLabel.textColor = Gen.Colors.black.color
        self.eMailTextContainerView.backgroundColor = Gen.Colors.white.color
        self.passwordCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWEngCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWNumCorrectLabel.textColor = Gen.Colors.gray04.color
        self.newPWSizeCorrectLabel.textColor = Gen.Colors.gray04.color
        self.confirmBtnView.backgroundColor = Gen.Colors.gray04.color
        self.confirmBtnTitleLabel.textColor = Gen.Colors.white.color
        self.currentPWTextContainerView.backgroundColor = Gen.Colors.white.color
        self.newPWTextContainerView.backgroundColor = Gen.Colors.white.color
        self.confirmBtnView.isHidden = true
        self.currentPWTextContainerView.backgroundColor = Gen.Colors.gray06.color
        self.newPWTextContainerView.backgroundColor = Gen.Colors.gray06.color
        self.newPWTextField.isEnabled = false
        self.currentPWTextField.isEnabled = false
        self.newPWTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요.", attributes: self.nonActivePlaceHolderAttributes)
        self.currentPWTextField.attributedPlaceholder = NSAttributedString(string: "현재 비밀번호를 입력해주세요.", attributes: self.nonActivePlaceHolderAttributes)
    }
    
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollContainerViewBottomConstraint.constant = self.originEMailIconWidthConstraint + keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        self.scrollContainerViewBottomConstraint.constant = self.originEMailIconWidthConstraint
    }
    
    // MARK: internal function
    
    // MARK: action

}
