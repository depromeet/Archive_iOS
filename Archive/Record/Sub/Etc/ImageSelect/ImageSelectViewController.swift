//
//  ImageSelectViewController.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Photos

class ImageSelectViewController: UIViewController, StoryboardView {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    
    // MARK: private property
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    var imageSelectView: HWPhotoListFromAlbumView?
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    init?(coder: NSCoder, reactor: ImageSelectReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: ImageSelectReactor) {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        setImageSelectView()
    }
    
    private func setImageSelectView() {
        self.imageSelectView = HWPhotoListFromAlbumView.loadFromNibNamed(nibNamed: "HWPhotoListFromAlbumView")
        guard let imageSelectView = self.imageSelectView else { return }
        imageSelectView.delegate = self
        imageSelectView.selectType = .multi
        self.mainContainerView.addSubview(imageSelectView)
        imageSelectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.mainContainerView)
        }
    }
    
    // MARK: internal function
    
    // MARK: action

}

extension ImageSelectViewController: HWPhotoListFromAlbumViewDelegate {
    func selectedImgsFromAlbum(selectedImg: [PHAsset: PhotoFromAlbumModel], focusIndexAsset: PHAsset) {
        
    }
}
