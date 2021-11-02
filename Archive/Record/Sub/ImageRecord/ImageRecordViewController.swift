//
//  ImageRecordViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ImageRecordViewControllerProtocol: AnyObject {
    func setRecordTitle(_ title: String)
    func hideTopView()
    func showTopView()
    
    var reactor: ImageRecordReactor? { get }
    var delegate: ImageRecordViewControllerDelegate? { get set }
}

protocol ImageRecordViewControllerDelegate: AnyObject {
    func clickedEmotionSelectArea(currentEmotion: Emotion?)
    func clickedPhotoSeleteArea()
    func clickedContentsArea()
    func addMorePhoto()
}

class ImageRecordViewController: UIViewController, StoryboardView, ImageRecordViewControllerProtocol {
    
    enum CellModel {
        case cover(UIImage)
        case commonImage(UIImage)
        case addImage(Void)
    }
    
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
    @IBOutlet weak var coverImageView: UIImageView!
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
    
    weak var delegate: ImageRecordViewControllerDelegate?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    init?(coder: NSCoder, reactor: ImageRecordReactor) {
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
    
    func bind(reactor: ImageRecordReactor) {
        self.addPhotoBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.clickedPhotoSeleteArea()
            })
            .disposed(by: self.disposeBag)
        
        self.emotionSelectBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.clickedEmotionSelectArea(currentEmotion: reactor.currentState.emotion)
            })
            .disposed(by: self.disposeBag)
        
        self.bottomBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.clickedContentsArea()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.emotion }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] emotion in
                self?.addPhotoImgView.isHidden = false
                self?.addPhotoBtn.isHidden = false
                switch emotion {
                case .fun:
                    self?.coverImageView.image = Gen.Images.coverFun.image
                    self?.topContainerView.backgroundColor = Gen.Colors.funYellow.color
                    self?.miniEmotionImageView.image = Gen.Images.typeFunMini.image
                    self?.emotionLabel.text = "재미있는"
                case .impressive:
                    self?.coverImageView.image = Gen.Images.coverImpressive.image
                    self?.topContainerView.backgroundColor = Gen.Colors.impressiveGreen.color
                    self?.miniEmotionImageView.image = Gen.Images.typeImpressiveMini.image
                    self?.emotionLabel.text = "인상적인"
                case .pleasant:
                    self?.coverImageView.image = Gen.Images.coverPleasant.image
                    self?.topContainerView.backgroundColor = Gen.Colors.pleasantRed.color
                    self?.miniEmotionImageView.image = Gen.Images.typePleasantMini.image
                    self?.emotionLabel.text = "기분좋은"
                case .splendid:
                    self?.coverImageView.image = Gen.Images.coverSplendid.image
                    self?.topContainerView.backgroundColor = Gen.Colors.splendidBlue.color
                    self?.miniEmotionImageView.image = Gen.Images.typeSplendidMini.image
                    self?.emotionLabel.text = "아름다운"
                case .wonderful:
                    self?.coverImageView.image = Gen.Images.coverWonderful.image
                    self?.topContainerView.backgroundColor = Gen.Colors.wonderfulPurple.color
                    self?.miniEmotionImageView.image = Gen.Images.typeWonderfulMini.image
                    self?.emotionLabel.text = "경이로운"
                }
            })
            .disposed(by: self.disposeBag)
            
        
        Observable.zip(reactor.state.map { $0.thumbnailImage }, reactor.state.map { $0.images }.map { $0 })
            .asDriver(onErrorJustReturn: (nil, nil))
            .drive(onNext: {[weak self] zippedImages in
                self?.imagesCollectionView.delegate = nil
                self?.imagesCollectionView.dataSource = nil
                guard let cardImage = zippedImages.0 else { return }
                guard let images = zippedImages.1 else { return }
                self?.defaultImageContainerView.isHidden = true
                self?.imagesCollectionView.isHidden = false
                self?.topContentsContainerView.backgroundColor = .clear
                var imageCellArr: [CellModel] = []
                for imageItem in images {
                    imageCellArr.append(CellModel.commonImage(imageItem))
                }
                let sections = Observable.just([
                    SectionModel(model: "card", items: [
                        CellModel.cover(cardImage)
                    ]),
                    SectionModel(model: "image", items: imageCellArr),
                    SectionModel(model: "addImage", items: [CellModel.addImage(())])
                ])
                guard let self = self else { return }
                let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { dataSource, collectionView, indexPath, item in
                    switch item {
                    case .cover(let image):
                        return self.makeCardCell(emotion: reactor.currentState.emotion, with: image, from: collectionView, indexPath: indexPath)
                    case .commonImage(let image):
                        return self.makeImageCell(emotion: reactor.currentState.emotion, with: image, from: collectionView, indexPath: indexPath)
                    case .addImage:
                        return self.makeAddImageCell(from: collectionView, indexPath: indexPath)
                    }
                })
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.scrollDirection = .horizontal
                layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: self.imagesCollectionView.bounds.height)
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.imagesCollectionView.collectionViewLayout = layout
                sections
                    .bind(to: self.imagesCollectionView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.imagesCollectionView.rx.willDisplayCell
            .asDriver()
            .compactMap { $0 }
            .drive(onNext: { [weak self] item in
                if item.at.section == 0 {
                    self?.emotionSelectView.isHidden = false
                } else {
                    self?.emotionSelectView.isHidden = true
                }
            })
            .disposed(by: self.disposeBag)
        
        self.imagesCollectionView.rx.itemSelected
            .asDriver()
            .compactMap { $0 }
            .drive(onNext: { [weak self] selectedItem in
                if selectedItem.section == 2 {
                    self?.delegate?.addMorePhoto()
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
        self.imagesCollectionView.showsHorizontalScrollIndicator = false
        self.imagesCollectionView.isHidden = true
        self.imagesCollectionView.register(UINib(nibName: RecordCardCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecordCardCollectionViewCell.identifier)
        self.imagesCollectionView.register(UINib(nibName: RecordImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecordImageCollectionViewCell.identifier)
        self.imagesCollectionView.register(UINib(nibName: RecordAddImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecordAddImageCollectionViewCell.identifier)
    }
    
    private func makeCardCell(emotion: Emotion?, with element: UIImage, from collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: RecordCardCollectionViewCell.identifier, for: indexPath) as? RecordCardCollectionViewCell else { return UICollectionViewCell() }
        cell.mainImageView.image = element
        cell.emotion = emotion
        return cell
    }
    
    private func makeImageCell(emotion: Emotion?, with element: UIImage, from collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: RecordImageCollectionViewCell.identifier, for: indexPath) as? RecordImageCollectionViewCell else { return UICollectionViewCell() }
        cell.mainImageView.image = element
        cell.emotion = emotion
        return cell
    }
    
    private func makeAddImageCell(from collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: RecordAddImageCollectionViewCell.identifier, for: indexPath) as? RecordAddImageCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    // MARK: internal function
    
    func setRecordTitle(_ title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.doWriteLabel.text = title
            self?.doWriteLabel.textColor = Gen.Colors.black.color
        }
    }
    
    func hideTopView() {
        self.topContainerView.isHidden = true
    }
    
    func showTopView() {
        self.topContainerView.isHidden = false
    }
    
    // MARK: action
    
    

    
    
    
}
