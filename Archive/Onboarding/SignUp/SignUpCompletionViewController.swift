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
import Lottie

final class SignUpCompletionViewController: UIViewController, StoryboardView, Stepper {
    @IBOutlet weak var startArchiveBtn: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    let steps = PublishRelay<Step>()
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
        self.animationView.backgroundColor = .clear
        self.animationView.animation = Animation.named("SignUp")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.loopMode = .loop
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animationView.play(completion: nil)
    }
    
    func bind(reactor: SignUpReactor) {
        startArchiveBtn.rx.tap
            .map { Reactor.Action.startArchive }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
