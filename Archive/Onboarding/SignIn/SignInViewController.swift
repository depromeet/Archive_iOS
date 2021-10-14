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
import RxFlow

final class SignInViewController: UIViewController, View, Stepper {
    
    @IBOutlet private weak var signUpButton: UIButton?
    
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 로직이 Reactor를 거치도록 수정
        signUpButton?.rx.tap
            .map { ArchiveStep.termsAgreementIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func bind(reactor: SignInReactor) {
        
    }
}
