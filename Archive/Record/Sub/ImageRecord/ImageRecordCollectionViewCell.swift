//
//  ImageRecordCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

protocol ImageRecordCollectionViewCellDelegate: AnyObject {
    func clickedContentsArea()
    func clickedEmotionSelectArea()
    func clickedPhotoSeleteArea()
}

class ImageRecordCollectionViewCell: UICollectionViewCell, StoryboardView, ClassIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var topContainerBackgroundView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var emotionMainImageView: UIImageView!
    @IBOutlet weak var topContentsContainerView: UIView!
    @IBOutlet weak var defaultImageContainerView: UIView!
    @IBOutlet weak var emotionSelectView: UIView!
    @IBOutlet weak var emotionSelectBtn: UIButton!
    @IBOutlet weak var miniEmotionImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var addPhotoImgView: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var doWriteLabel: UILabel!
    @IBOutlet weak var bottomBtn: UIButton!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: private property
    
    // MARK: internal property
    
    weak var delegate: ImageRecordCollectionViewCellDelegate?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func bind(reactor: ImageRecordReactor) {
        self.addPhotoBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.clickedPhotoSeleteArea()
            })
            .disposed(by: self.disposeBag)
        
        self.emotionSelectBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.clickedEmotionSelectArea()
            })
            .disposed(by: self.disposeBag)
        
        self.bottomBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.clickedContentsArea()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.images }
        .asDriver(onErrorJustReturn: [])
        .drive(onNext: { [weak self] images in
            if images.count == 0 {
                self?.defaultImageContainerView.isHidden = false
            } else {
                print("images set!! :\(images)")
                self?.defaultImageContainerView.isHidden = true
            }
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.topContainerBackgroundView.backgroundColor = Gen.Colors.gray05.color
        self.topContainerView.backgroundColor = .clear
        self.topContentsContainerView.backgroundColor = .clear
        self.emotionSelectView.backgroundColor = .clear
        self.emotionSelectView.layer.cornerRadius = 8
        self.emotionSelectView.layer.borderWidth = 1
        self.emotionSelectView.layer.borderColor = Gen.Colors.black.color.cgColor
        
        self.emotionLabel.font = .fonts(.subTitle)
        self.emotionLabel.textColor = Gen.Colors.black.color
        self.emotionLabel.text = "전시가 어땠나요?"
        
        self.bottomContainerView.backgroundColor = Gen.Colors.white.color
        
        self.helpLabel.font = .fonts(.subTitle)
        self.helpLabel.textColor = Gen.Colors.black.color
        self.helpLabel.text = "무슨 전시를 감상했나요?"
        
        self.doWriteLabel.font = .fonts(.header2)
        self.doWriteLabel.textColor = Gen.Colors.gray03.color
        self.doWriteLabel.text = "전시명을 입력해주세요."
        
        self.addPhotoImgView.isHidden = true
        self.addPhotoBtn.isHidden = true
        self.imagesCollectionView.isHidden = true
    }
    
    // MARK: internal function
    
    func selectEmotion(_ emotion: Emotion) {
        switch emotion {
        case .fun:
            self.topContainerView.backgroundColor = Gen.Colors.funYellow.color
            self.emotionMainImageView.image = Gen.Images.coverFun.image
            self.miniEmotionImageView.image = Gen.Images.typeFunMini.image
            self.emotionLabel.text = "재미있는"
        case .impressive:
            self.topContainerView.backgroundColor = Gen.Colors.impressiveGreen.color
            self.emotionMainImageView.image = Gen.Images.coverImpressive.image
            self.miniEmotionImageView.image = Gen.Images.typeImpressiveMini.image
            self.emotionLabel.text = "인상적인"
        case .pleasant:
            self.topContainerView.backgroundColor = Gen.Colors.pleasantRed.color
            self.emotionMainImageView.image = Gen.Images.coverPleasant.image
            self.miniEmotionImageView.image = Gen.Images.typePleasantMini.image
            self.emotionLabel.text = "기분좋은"
        case .splendid:
            self.topContainerView.backgroundColor = Gen.Colors.splendidBlue.color
            self.emotionMainImageView.image = Gen.Images.coverSplendid.image
            self.miniEmotionImageView.image = Gen.Images.typeSplendidMini.image
            self.emotionLabel.text = "아름다운"
        case .wonderful:
            self.topContainerView.backgroundColor = Gen.Colors.wonderfulPurple.color
            self.emotionMainImageView.image = Gen.Images.coverWonderful.image
            self.miniEmotionImageView.image = Gen.Images.typeWonderfulMini.image
            self.emotionLabel.text = "경이로운"
        }
        self.addPhotoImgView.isHidden = false
        self.addPhotoBtn.isHidden = false
    }
    
    func setRecordTitle(_ title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.doWriteLabel.text = title
            self?.doWriteLabel.textColor = Gen.Colors.black.color
        }
    }
    
    // MARK: action
    
    

    
    
    
}
