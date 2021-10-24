//
//  RecordViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

class RecordViewController: UIViewController, StoryboardView {

    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: RecordReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: RecordReactor) {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        
    }
    
    // MARK: internal function
    
    // MARK: action

}
