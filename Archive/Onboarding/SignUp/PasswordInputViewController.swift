//
//  PasswordInputViewController.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

final class PasswordInputViewController: UIViewController, StoryboardView {
    
    private enum Constant {
        static let progress: Float = 1
    }
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var passwordInputView: InputView!
    @IBOutlet private weak var englishCombinationCheckView: ConditionCheckmarkView!
    @IBOutlet private weak var numberCombinationCheckView: ConditionCheckmarkView!
    @IBOutlet private weak var countCheckView: ConditionCheckmarkView!
    @IBOutlet private weak var passwordConfirmInputView: InputView!
    @IBOutlet private weak var passwordCofirmCheckView: ConditionCheckmarkView!
    @IBOutlet private weak var nextButton: UIButton!
    var disposeBag = DisposeBag()
    
    init?(coder: NSCoder, reactor: SignUpReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.setProgress(Constant.progress, animated: true)
    }
    
    func bind(reactor: SignUpReactor) {
        passwordInputView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.passwordInput(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordConfirmInputView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.passwordCofirmInput(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton?.rx.tap
            .map { Reactor.Action.completeSignUp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isContainsEnglish }
            .distinctUntilChanged()
            .bind(to: englishCombinationCheckView.rx.isValid)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isContainsNumber }
            .distinctUntilChanged()
            .bind(to: numberCombinationCheckView.rx.isValid)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isWithinRange }
            .distinctUntilChanged()
            .bind(to: countCheckView.rx.isValid)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSamePasswordInput }
            .distinctUntilChanged()
            .bind(to: passwordCofirmCheckView.rx.isValid)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isValidPassword }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
