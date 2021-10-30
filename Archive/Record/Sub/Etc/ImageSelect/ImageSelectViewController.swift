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

class ImageSelectViewController: UIViewController, StoryboardView, ActivityIndicatorable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var imageThumnailContainerView: UIView!
    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var imageAlbumContainerView: UIView!
    
    // MARK: private property
    
    private var confirmBtn: UIBarButtonItem?
    
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
        reactor.isLoading
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
            .map { $0.selectedImageInfo }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] asset in
                self?.imageThumnailContainerView.backgroundColor = Gen.Colors.white.color
                guard let asset = asset else { return }
                self?.phAssetToImage(asset, ImageSize: CGSize(width: 300, height: 300), completion: { [weak self] image in
                    self?.thumnailImageView.image = image
                })
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        self.imageThumnailContainerView.backgroundColor = Gen.Colors.gray03.color
        setImageSelectView()
        makeConfirmBtn()
        makeCancelBtn()
    }
    
    private func setImageSelectView() {
        self.imageSelectView = HWPhotoListFromAlbumView.loadFromNibNamed(nibNamed: "HWPhotoListFromAlbumView")
        guard let imageSelectView = self.imageSelectView else { return }
        imageSelectView.delegate = self
        imageSelectView.selectType = .multi
        self.imageAlbumContainerView.addSubview(imageSelectView)
        imageSelectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.imageAlbumContainerView)
        }
    }
    
    private func makeConfirmBtn() {
        self.confirmBtn = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(confirmAction(_:)))
        setConfirmBtnColor(Gen.Colors.gray04.color)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.removeAll()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = confirmBtn
    }
    
    private func setConfirmBtnColor(_ color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.confirmBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .normal)
            self?.confirmBtn?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fonts(.button), NSAttributedString.Key.foregroundColor: color], for: .highlighted)
        }
    }
    
    private func setConfirmBtnTitle(_ title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.confirmBtn?.title = title
        }
    }
    
    private func removeConfrimBtn() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.removeAll()
    }
    
    private func makeCancelBtn() {
        let cancelBtn: UIBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction(_:)))
        setConfirmBtnColor(Gen.Colors.black.color)
        self.navigationController?.navigationBar.topItem?.leftBarButtonItems?.removeAll()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelBtn
    }
    
    private func phAssetToImage(_ assets: PHAsset, ImageSize: CGSize, completion: @escaping (UIImage) -> Void) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        manager.requestImage(for: assets, targetSize: ImageSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            if result != nil {
                completion(result!)
            }
        })
    }
    
    // MARK: internal function
    
    // MARK: action
    
    @objc private func confirmAction(_ sender: UIButton) {
        self.reactor?.action.onNext(.confirm)
    }
    
    @objc private func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ImageSelectViewController: HWPhotoListFromAlbumViewDelegate {
    func changeFocusImg(focusIndex: Int) {
        
    }
    
    func selectedImgsFromAlbum(selectedImg: [PHAsset: PhotoFromAlbumModel], focusIndexAsset: PHAsset) {
        if selectedImg.count == 0 {
            self.setConfirmBtnTitle("선택")
            self.setConfirmBtnColor(Gen.Colors.gray04.color)
        } else {
            self.setConfirmBtnTitle("선택(\(selectedImg.count))")
            self.setConfirmBtnColor(Gen.Colors.black.color)
        }
        self.reactor?.action.onNext(.setImageInfos(selectedImg))
        self.reactor?.action.onNext(.setSelectedImageInfo(focusIndexAsset))
    }
}
