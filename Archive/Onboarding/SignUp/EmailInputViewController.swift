//
//  EmailInputViewController.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

final class EmailInputViewController: UIViewController, StoryboardView {
    
    private enum Constant {
        static let progress: Float = 0.66
    }
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var emailInputView: InputView!
    @IBOutlet private weak var validationResultLabel: UILabel!
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
        setupAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.setProgress(Constant.progress, animated: true)
    }
    
    private func setupAttributes() {
        let tapOutside = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapOutside)
    }
    
    func bind(reactor: SignUpReactor) {
        emailInputView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.emailInput(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailInputView.rx.tapRightButton
            .map { Reactor.Action.checkEmailDuplicate }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.goToPasswordInput }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isValidEmail }
            .distinctUntilChanged()
            .bind(to: emailInputView.rx.isEnabledRightButton)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.emailValidationText }
            .skip(1)
            .distinctUntilChanged()
            .bind(to: validationResultLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCompleteEmailInput }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
