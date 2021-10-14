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

final class EmailInputViewController: UIViewController, View, Stepper {
    
    @IBOutlet private weak var nextButton: UIButton?
    
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 로직이 Reactor를 거치도록 수정
        nextButton?.rx.tap
            .map { ArchiveStep.passwordInputRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func bind(reactor: SignUpReactor) {
        
    }
}
