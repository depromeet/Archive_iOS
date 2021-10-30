//
//  ImageCropViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa


class ImageCropViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: ImageCropReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: ImageCropReactor) {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        
    }
    
    // MARK: internal function
    
    // MARK: action
    

}

