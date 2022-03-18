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
import AuthenticationServices

final class SignInViewController: UIViewController, StoryboardView, ActivityIndicatorable, SplashViewProtocol, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet private weak var idInputView: InputView!
    @IBOutlet private weak var passwordInputView: InputView!
    @IBOutlet private weak var signInButton: DefaultButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet weak var testView: UIView!
    
    
    
    
    var disposeBag = DisposeBag()
    weak var targetView: UIView?
    var attachedView: UIView? = SplashView.instance()
    
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
        runSplashView()
    }
    
    @IBAction func testAction(_ sender: Any) {
        appleSignInButtonPress()
    }
    
    // Apple Login Button Pressed
    @objc func appleSignInButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error: \(error.localizedDescription)")
        // Handle error.
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
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
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
    
    private func runSplashView() {
        if !AppConfigManager.shared.isPlayedIntroSplashView {
            AppConfigManager.shared.isPlayedIntroSplashView = true
            self.targetView = self.mainContainerView
            showSplashView(completion: {
                (self.attachedView as? SplashView)?.play()
            })
            (self.attachedView as? SplashView)?.isFinishAnimationFlag
                .asDriver(onErrorJustReturn: true)
                .drive(onNext: { [weak self] in
                    if $0 {
                        self?.hideSplashView(completion: { [weak self] in
                            self?.attachedView = nil
                        })
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }
}
