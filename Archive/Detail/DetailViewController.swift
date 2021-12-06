//
//  DetailViewController.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class DetailViewController: UIViewController, StoryboardView, ActivityIndicatorable {
    
    enum CellModel {
        case cover(RecordData)
        case commonImage(RecordImageData)
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var archiveTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: private property
    
    private let photoContentsView: DetailPhotoContentsView? = DetailPhotoContentsView.instance()
    private let modalShareViewController: ModalShareViewController = ModalShareViewController.init(nibName: "ModalShareViewController", bundle: nil)
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: DetailReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: DetailReactor) {
        reactor.state
            .map { $0.detailData }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] info in
                self?.setCardInfo(info)
                self?.collectionView.delegate = nil
                self?.collectionView.dataSource = nil
                guard let images = info.images else { return }
                self?.pageControl.numberOfPages = images.count + 1
                var imageCellArr: [CellModel] = []
                for imageItem in images {
                    imageCellArr.append(CellModel.commonImage(imageItem))
                }
                let sections = Observable.just([
                    SectionModel(model: "card", items: [
                        CellModel.cover(info)
                    ]),
                    SectionModel(model: "image", items: imageCellArr)
                ])
                guard let self = self else { return }
                let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { dataSource, collectionView, indexPath, item in
                    switch item {
                    case .cover(let infoData):
                        return self.makeCardCell(with: infoData, from: collectionView, indexPath: indexPath)
                    case .commonImage(let imageInfo):
                        return self.makeImageCell(with: imageInfo, from: collectionView, indexPath: indexPath)
                    }
                })
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.scrollDirection = .horizontal
                let width = UIScreen.main.bounds.width
                let height = width * 520 / 375
                layout.itemSize = CGSize(width: width, height: height)
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.collectionView.collectionViewLayout = layout
                sections
                    .bind(to: self.collectionView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { [weak self] info in
                if info.at.section == 0 {
                    self?.pageControl.currentPage = 0
                } else {
                    self?.pageControl.currentPage = info.at.item + 1
                }
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { [weak self] info in
                if info.at.section == 0 {
                    self?.photoContentsView?.isHidden = true
                } else {
                    self?.photoContentsView?.isHidden = false
                    if let imageInfo = reactor.currentState.detailData?.images?[info.at.item] {
                        self?.photoContentsView?.imageInfo = imageInfo
                        self?.photoContentsView?.index = info.at.item
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.shareActivityController }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] controller in
                self?.modalShareViewController.dismiss(animated: false, completion: { [weak self] in
                    controller.isModalInPresentation = true
                    controller.excludedActivityTypes = [.airDrop, .message]
                    self?.present(controller, animated: true, completion: nil)
                })
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.startIndicatorAnimating()
                } else {
                    self?.stopIndicatorAnimating()
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isDeletedArchive }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isDeleted in
                if isDeleted {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    deinit {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.topContainerView.backgroundColor = Gen.Colors.white.color
        self.collectionView.backgroundColor = .clear
        
        self.bottomContainerView.backgroundColor = Gen.Colors.white.color
        self.archiveTitleLabel.font = .fonts(.header2)
        self.archiveTitleLabel.textColor = Gen.Colors.black.color
        self.dateLabel.font = .fonts(.header3)
        self.dateLabel.textColor = Gen.Colors.black.color
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UINib(nibName: DetailMainCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DetailMainCollectionViewCell.identifier)
        self.collectionView.register(UINib(nibName: DetailContentsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DetailContentsCollectionViewCell.identifier)
        
        self.pageControl.pageIndicatorTintColor = Gen.Colors.gray03.color
        self.pageControl.currentPageIndicatorTintColor = Gen.Colors.gray01.color
        
        if let photoContentsView = self.photoContentsView {
            self.bottomContainerView.addSubview(photoContentsView)
            photoContentsView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            photoContentsView.isHidden = true
        }
        
        makeNaviBtn()
    }
    
    private func makeCardCell(with element: RecordData, from collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailMainCollectionViewCell.identifier, for: indexPath) as? DetailMainCollectionViewCell else { return UICollectionViewCell() }
        cell.infoData = element
        return cell
    }
    
    private func makeImageCell(with element: RecordImageData, from collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailContentsCollectionViewCell.identifier, for: indexPath) as? DetailContentsCollectionViewCell else { return UICollectionViewCell() }
        cell.imageInfo = element
        return cell
    }
    
    private func setCardInfo(_ info: RecordData) {
        self.archiveTitleLabel.text = info.name
        self.dateLabel.text = info.watchedOn
    }
    
    private func makeNaviBtn() {
        let moreImage = Gen.Images.moreVertBlack24dp.image
        moreImage.withRenderingMode(.alwaysTemplate)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(moreButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = moreBarButtonItem
        
        let backImage = Gen.Images.back.image
        backImage.withRenderingMode(.alwaysTemplate)
        let backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked(_:)))
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    // MARK: internal function
    
    // MARK: action
    
    @objc private func moreButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: "삭제", style: .default) { (delete) in
            CommonAlertView.shared.show(message: "기록을 삭제하겠습니까?", subMessage: "삭제된 이미지와 글은 복구가 불가능합니다.", confirmBtnTxt: "삭제", cancelBtnTxt: "취소", confirmHandler: { [weak self] in
                CommonAlertView.shared.hide(nil)
                self?.reactor?.action.onNext(.deleteArchive)
            }, cancelHandler: {
                CommonAlertView.shared.hide(nil)
            })
        }
        let shareAction: UIAlertAction = UIAlertAction(title: "공유", style: .default) { [weak self] (share) in
            self?.modalShareViewController.modalPresentationStyle = .overFullScreen
            self?.modalShareViewController.delegate = self
            self?.present(self!.modalShareViewController, animated: false, completion: {
                self?.modalShareViewController.fadeIn()
            })
        }
        alert.addAction(deleteAction)
        alert.addAction(shareAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc private func backButtonClicked(_ sender: UIButton) {
        print("backButtonClicked")
    }

}

extension DetailViewController: ModalShareViewControllerDelegate {
    func instagramShareClicked() {
        self.reactor?.action.onNext(.shareToInstagram)
    }
    
    func photoShareClicked() {
        self.reactor?.action.onNext(.saveToAlbum)
    }
}
