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
import GrowingTextView

protocol ContentsRecordViewControllerProtocol: AnyObject {
    func setEmotion(_ emotion: Emotion?)
}

class ContentsRecordViewController: UIViewController, StoryboardView, ContentsRecordViewControllerProtocol {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var mainContentsView: UIView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventNameTextView: GrowingTextView!
    @IBOutlet weak var eventNameTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventCancelBtn: UIButton!
    @IBOutlet weak var eventUnderLineView: UIView!
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateUnderLineView: UIView!
    
    @IBOutlet weak var friendsTitleLabel: UILabel!
    @IBOutlet weak var friendsTextView: GrowingTextView!
    @IBOutlet weak var friendsTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsCancelBtn: UIButton!
    @IBOutlet weak var friendsUnderLineView: UIView!
    @IBOutlet weak var friendsHelpLabel: UILabel!
    
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
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.mainContentsView.backgroundColor = .clear
        
        self.eventTitleLabel.font = .fonts(.subTitle)
        self.eventTitleLabel.textColor = Gen.Colors.black.color
        self.eventTitleLabel.text = "무슨 전시를 감상했나요?"
        
        self.eventNameTextView.font = .fonts(.header2)
        self.eventNameTextView.textColor = Gen.Colors.black.color
        self.eventNameTextView.placeholderColor = Gen.Colors.gray03.color
        self.eventNameTextView.placeholder = "전시명을 입력해주세요."
        self.eventNameTextView.textContainerInset = .zero
        self.eventNameTextView.maxHeight = self.eventNameTextViewHeightConstraint.constant * 3
        
        self.eventUnderLineView.backgroundColor = Gen.Colors.gray03.color
        
        self.dateTitleLabel.font = .fonts(.subTitle)
        self.dateTitleLabel.textColor = Gen.Colors.black.color
        self.dateTitleLabel.text = "언제 전시를 감상했나요?"
        
        self.dateTextField.font = .fonts(.header2)
        self.dateTextField.textColor = Gen.Colors.black.color
        self.dateTextField.placeholder = "YY/MM/DD"
        
        self.dateUnderLineView.backgroundColor = Gen.Colors.gray03.color
        
        self.friendsTitleLabel.font = .fonts(.subTitle)
        self.friendsTitleLabel.textColor = Gen.Colors.black.color
        self.friendsTitleLabel.text = "누구와 관람하셨나요?"
        
        self.friendsTextView.font = .fonts(.header2)
        self.friendsTextView.textColor = Gen.Colors.black.color
        self.friendsTextView.placeholderColor = Gen.Colors.gray03.color
        self.friendsTextView.placeholder = "동행인은 쉼표로 구분됩니다."
        self.friendsTextView.textContainerInset = .zero
        self.friendsTextView.maxHeight = self.friendsTextViewHeightConstraint.constant * 3
        
        self.friendsUnderLineView.backgroundColor = Gen.Colors.gray03.color
        
        self.friendsHelpLabel.font = .fonts(.button)
        self.friendsHelpLabel.textColor = Gen.Colors.gray03.color
        self.friendsHelpLabel.text = "*이름은 5자까지 작성 가능합니다."
    }
    
    // MARK: internal function
    
    func setEmotion(_ emotion: Emotion?) {
        self.topCardView.backgroundColor = Gen.Colors.white.color
        guard let emotion = emotion else { return }
        switch emotion {
        case .fun:
            self.topCardView.backgroundColor = Gen.Colors.funYellow.color
        case .impressive:
            self.topCardView.backgroundColor = Gen.Colors.impressiveGreen.color
        case .pleasant:
            self.topCardView.backgroundColor = Gen.Colors.pleasantRed.color
        case .splendid:
            self.topCardView.backgroundColor = Gen.Colors.splendidBlue.color
        case .wonderful:
            self.topCardView.backgroundColor = Gen.Colors.wonderfulPurple.color
        }
    }
    
    // MARK: action

}
