//
//  SignUpCompletionViewController.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

final class SignUpCompletionViewController: UIViewController, View, Stepper {
    
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bind(reactor: SignUpReactor) {
        
    }
}
