//
//  SignInViewController.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/02.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController, StoryboardView, ActivityIndicatorable {
    
    @IBOutlet private weak var idInputView: InputView!
    @IBOutlet private weak var passwordInputView: InputView!
    @IBOutlet private weak var signInButton: DefaultButton!
    @IBOutlet private weak var signUpButton: UIButton!
    var disposeBag = DisposeBag()
    
    init?(coder: NSCoder, reactor: SignInReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupAttributes() {
        let tapOutside = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapOutside)
        
        idInputView.rx.editingDidEndOnExit
            .subscribe(onNext: { [weak self] in
                self?.passwordInputView.focusTextField()
            })
            .disposed(by: disposeBag)
        self.idInputView.placeholder = "아이디(이메일)"
        self.passwordInputView.placeholder = "영문/숫자포함 8~20자"
        self.passwordInputView.isSecureTextEntry = true
    }
    
    func bind(reactor: SignInReactor) {
        idInputView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.idInput(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordInputView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.passwordInput(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .map { Reactor.Action.signIn }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .map { Reactor.Action.signUp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnableSignIn }
            .distinctUntilChanged()
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { errorMsg in
                CommonAlertView.shared.show(message: errorMsg, btnText: "확인", hapticType: .error, confirmHandler: {
                    CommonAlertView.shared.hide(nil)
                })
            })
            .disposed(by: self.disposeBag)
    }
}
