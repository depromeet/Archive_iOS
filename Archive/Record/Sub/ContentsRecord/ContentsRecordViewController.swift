//
//  ContentsRecordViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

protocol ContentsRecordViewControllerProtocol: AnyObject {
    
}

class ContentsRecordViewController: UIViewController, StoryboardView, ContentsRecordViewControllerProtocol {

    
    
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    init?(coder: NSCoder, reactor: ContentsRecordReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func bind(reactor: ContentsRecordReactor) {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        
    }
    
    // MARK: internal function
    
    // MARK: action

}
