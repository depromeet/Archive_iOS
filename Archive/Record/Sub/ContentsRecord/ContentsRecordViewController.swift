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
    
    var delegate: ContentsRecordViewControllerDelegate? { get set }
}

protocol ContentsRecordViewControllerDelegate: AnyObject {
    func completeContentsRecord(infoData: ContentsRecordModelData)
    func moveToBeforeViewController()
}

class ContentsRecordViewController: UIViewController, StoryboardView, ContentsRecordViewControllerProtocol {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var mainContentsView: UIView!
    @IBOutlet weak var upBtn: UIButton!
    
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
    
    private var datePicker: UIDatePicker!
    private var originalScrollContainerViewBottomConstraint: CGFloat = 0
    var editBtn: UIBarButtonItem?
    
    // MARK: internal property
    
    var disposeBag: DisposeBag = DisposeBag()
    weak var delegate: ContentsRecordViewControllerDelegate?
    
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
        makeDataPicker()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        makeConfirmBtn()
        self.reactor?.action.onNext(.clearCompleteData)
    }
    
    func bind(reactor: ContentsRecordReactor) {
        
        self.upBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.removeConfrimBtn()
                self?.delegate?.moveToBeforeViewController()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.contentsDate }
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] dateStr in
                self?.dateTextField.text = dateStr
            })
            .disposed(by: self.disposeBag)
        
        self.eventNameTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                reactor.action.onNext(.setContentsTitle(self?.eventNameTextView.text ?? ""))
            })
            .disposed(by: self.disposeBag)
        
        self.eventCancelBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.eventNameTextView.resignFirstResponder()
                self?.eventNameTextView.text = ""
                reactor.action.onNext(.setContentsTitle(""))
            })
            .disposed(by: self.disposeBag)
        
        self.friendsTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                reactor.action.onNext(.setFriends(self?.friendsTextView.text ?? ""))
            })
            .disposed(by: self.disposeBag)
        
        self.friendsCancelBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.friendsTextView.resignFirstResponder()
                self?.friendsTextView.text = ""
                reactor.action.onNext(.setFriends(""))
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isAllContentsSetted }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isAllContentsSetted in
                if isAllContentsSetted {
                    self?.setEditBtnColor(Gen.Colors.black.color)
                } else {
                    self?.setEditBtnColor(Gen.Colors.gray04.color)
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.complete }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] infoData in
                guard let info = infoData else { return }
                self?.removeConfrimBtn()
                self?.delegate?.completeContentsRecord(infoData: info)
            })
            .disposed(by: self.disposeBag)
        
    }
    
    
    // MARK: private function
    
    private func initUI() {
        self.originalScrollContainerViewBottomConstraint = self.scrollContainerViewBottomConstraint.constant
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
        self.eventNameTextView.showsVerticalScrollIndicator = false
        let eventNameTextViewDoneButton = UIBarButtonItem.init(title: "완료", style: .done, target: self, action: #selector(self.titleTextViewDone))
        let eventNameTextViewToolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        eventNameTextViewToolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), eventNameTextViewDoneButton], animated: true)
        self.eventNameTextView.inputAccessoryView = eventNameTextViewToolBar
        
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
        self.friendsTextView.showsVerticalScrollIndicator = false
        let friendsTextViewDoneButton = UIBarButtonItem.init(title: "완료", style: .done, target: self, action: #selector(self.friendsTextViewDone))
        let friendsTextViewToolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        friendsTextViewToolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), friendsTextViewDoneButton], animated: true)
        self.friendsTextView.inputAccessoryView = friendsTextViewToolBar
        
        self.friendsUnderLineView.backgroundColor = Gen.Colors.gray03.color
        
        self.friendsHelpLabel.font = .fonts(.button)
        self.friendsHelpLabel.textColor = Gen.Colors.gray03.color
        self.friendsHelpLabel.text = "*이름은 5자까지 작성 가능합니다."
    }
    
    private func makeDataPicker() {
        self.datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        self.datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
        self.dateTextField.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "완료", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        self.dateTextField.inputAccessoryView = toolBar
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollContainerViewBottomConstraint.constant = self.originalScrollContainerViewBottomConstraint - keyboardSize.height
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.scrollContainerViewBottomConstraint.constant = self.originalScrollContainerViewBottomConstraint
    }
    
    private func makeConfirmBtn() {
        self.editBtn = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(confirmAction(_:)))
        setEditBtnColor(Gen.Colors.gray04.color)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.removeAll()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = editBtn
    }
    
    private func setEditBtnColor(_ color: UIColor) {
        self.editBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .normal)
        self.editBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .highlighted)
    }
    
    private func removeConfrimBtn() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.removeAll()
    }
    
    // MARK: internal function
    
    func setEmotion(_ emotion: Emotion?) {
        self.topCardView.backgroundColor = Gen.Colors.pleasantRed.color
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
    
    @objc private func datePickerDone() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        self.reactor?.action.onNext(.setContentsDate(dateFormatter.string(from: datePicker.date)))
        self.dateTextField.resignFirstResponder()
    }
    
    @objc private func titleTextViewDone() {
        self.eventNameTextView.resignFirstResponder()
    }
    
    @objc private func friendsTextViewDone() {
        self.friendsTextView.resignFirstResponder()
    }
    
    @objc private func confirmAction(_ sender: UIButton) {
        if self.reactor?.currentState.isAllContentsSetted ?? false {
            self.reactor?.action.onNext(.confirm)
        }
    }

}
