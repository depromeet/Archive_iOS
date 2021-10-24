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
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        self.backgroundContainerView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.isScrollEnabled = false
        
        // 이하 테스트코드
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: ImageRecordCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageRecordCollectionViewCell.identifier)
        self.collectionView.register(UINib(nibName: ContentsRecordCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ContentsRecordCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: internal function
    
    // MARK: action

}

extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let resultCnt = 2
        
        return resultCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageRecordCollectionViewCell.identifier, for: indexPath) as? ImageRecordCollectionViewCell else { return UICollectionViewCell() }
            cell.reactor = ImageRecordReactor(model: ImageRecordModel())
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsRecordCollectionViewCell.identifier, for: indexPath) as? ContentsRecordCollectionViewCell else { return UICollectionViewCell() }
            cell.reactor = ContentsRecordReactor(model: ContentsRecordModel())
//            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.bounds.height)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets: UIEdgeInsets = .init(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        return edgeInsets
    }
    
}


extension RecordViewController: ImageRecordCollectionViewCellDelegate {
    func clickedContentsArea() {
        
    }
}
