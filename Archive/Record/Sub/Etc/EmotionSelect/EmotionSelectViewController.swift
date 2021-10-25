//
//  EmotionSelectViewController.swift
//  Archive
//
//  Created by hanwe lee on 2021/10/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EmotionSelectViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContentsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var contentsLabel: UILabel!
    
    @IBOutlet weak var pleasantBtn: UIButton!
    @IBOutlet weak var funBtn: UIButton!
    @IBOutlet weak var splendidBtn: UIButton!
    @IBOutlet weak var wonderfulBtn: UIButton!
    @IBOutlet weak var impressiveBtn: UIButton!
    
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
//        @IBOutlet weak var pleasantBtn: UIButton!
//        @IBOutlet weak var funBtn: UIButton!
//        @IBOutlet weak var splendidBtn: UIButton!
//        @IBOutlet weak var wonderfulBtn: UIButton!
//        @IBOutlet weak var impressiveBtn: UIButton!
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.dim.color
        self.mainContentsView.backgroundColor = .clear
        self.bottomView.backgroundColor = Gen.Colors.white.color
        self.titleLabel.font = .fonts(.header3)
        self.titleLabel.textColor = Gen.Colors.gray01.color
        self.titleLabel.text = "전시가 어땠나요?"
        
        self.completeBtn.titleLabel?.font = .fonts(.button)
        self.completeBtn.setTitle("완료", for: .normal)
        self.completeBtn.setTitle("완료", for: .highlighted)
        
        self.completeBtn.setTitleColor(Gen.Colors.black.color, for: .normal)
        self.completeBtn.setTitleColor(Gen.Colors.black.color, for: .highlighted)
        
        self.contentsLabel.font = .fonts(.body)
        self.contentsLabel.textColor = Gen.Colors.gray02.color
        self.contentsLabel.text = "선택한 감정으로 티켓 "
    }
    
    // MARK: internal function
    
    // MARK: action

}
