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

final class SignUpCompletionViewController: UIViewController, StoryboardView, Stepper {
    @IBOutlet weak var startArchiveBtn: UIButton!
    
    let steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    
    init?(coder: NSCoder, reactor: SignUpReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bind(reactor: SignUpReactor) {
        startArchiveBtn.rx.tap
            .map { Reactor.Action.startArchive }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
