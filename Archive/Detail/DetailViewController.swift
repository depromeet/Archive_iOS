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

class DetailViewController: UIViewController, StoryboardView {
    
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
    
    @IBOutlet weak var bottomContainerCiew: UIView!
    @IBOutlet weak var archiveTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
   
    
    // MARK: private property
    
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
        print("d")
        reactor.state
            .map { $0.detailData }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] info in
                print("음")
                self?.collectionView.delegate = nil
                self?.collectionView.dataSource = nil
                guard let images = info.images else { return }
                self?.pageControl.numberOfPages = images.count + 1
//                self?.defaultImageContainerView.isHidden = true
//                self?.imagesCollectionView.isHidden = false
//                self?.topContentsContainerView.backgroundColor = .clear
                var imageCellArr: [CellModel] = []
                for imageItem in images {
                    imageCellArr.append(CellModel.commonImage(imageItem))
                }
                let sections = Observable.just([
                    SectionModel(model: "card", items: [
                        CellModel.cover(info)
                    ]),
                    SectionModel(model: "image", items: imageCellArr),
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
                layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.bounds.height)
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.collectionView.collectionViewLayout = layout
                sections
                    .bind(to: self.collectionView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }
    
    deinit {
        
    }
    
    // MARK: private function
    
    private func initUI() {
//        self.mainContainerView.backgroundColor = .clear
//        self.scrollContainerView.backgroundColor = .clear
//        self.scrollView.backgroundColor = .clear
        
        self.mainContainerView.backgroundColor = .gray
//
//        @IBOutlet weak var topContainerView: UIView!
//        @IBOutlet weak var collectionView: UICollectionView!
//
//        @IBOutlet weak var bottomContainerCiew: UIView!
//        @IBOutlet weak var archiveTitleLabel: UILabel!
//        @IBOutlet weak var dateLabel: UILabel!
//
//        @IBOutlet weak var pageControl: UIPageControl!
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isHidden = true
        self.collectionView.register(UINib(nibName: DetailMainCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DetailMainCollectionViewCell.identifier)
        self.collectionView.register(UINib(nibName: DetailContentsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DetailContentsCollectionViewCell.identifier)
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
    // MARK: internal function
    
    // MARK: action

}
