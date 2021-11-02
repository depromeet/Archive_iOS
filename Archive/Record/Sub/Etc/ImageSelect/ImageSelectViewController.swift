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
import CropViewController

class ImageSelectViewController: UIViewController, StoryboardView, ActivityIndicatorable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var imageThumbnailContainerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var imageAlbumContainerView: UIView!
    
    // MARK: private property
    
    private var confirmBtn: UIBarButtonItem?
    
    // MARK: internal property
    var disposeBag: DisposeBag = DisposeBag()
    var imageSelectView: HWPhotoListFromAlbumView?
    
    // MARK: lifeCycle
    
    deinit {
        
    }
    
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
                self?.imageThumbnailContainerView.backgroundColor = Gen.Colors.white.color
                guard let asset = asset else { return }
                self?.phAssetToImage(asset, ImageSize: CGSize(width: 300, height: 300), completion: { [weak self] image in
                    self?.thumbnailImageView.image = image
                })
            })
            .disposed(by: self.disposeBag)
        
        reactor.presentCrop
            .asDriver(onErrorJustReturn: UIImage())
            .drive(onNext: { [weak self] image in
                self?.showImageEditView(image: image)
            })
            .disposed(by: self.disposeBag)
        
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.mainContainerView.backgroundColor = .clear
        self.imageThumbnailContainerView.backgroundColor = Gen.Colors.gray03.color
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
    
    private func getEmotionCoverImage(_ emotion: Emotion) -> UIImage {
        var returnImage: UIImage = UIImage()
        switch emotion {
        case .fun:
            returnImage = Gen.Images.dimFun.image
        case .impressive:
            returnImage = Gen.Images.dimImpressive.image
        case .pleasant:
            returnImage = Gen.Images.dimPleasant.image
        case .splendid:
            returnImage = Gen.Images.dimSplendid.image
        case .wonderful:
            returnImage = Gen.Images.dimWonderful.image
        }
        return returnImage
    }
    
    private func showImageEditView(image: UIImage) {
        let cropViewController: CropViewController = CropViewController(croppingStyle: .default, image: image)
        cropViewController.delegate = self
        cropViewController.doneButtonTitle = "확인"
        cropViewController.doneButtonColor = Gen.Colors.white.color
        cropViewController.cancelButtonTitle = "취소"
        cropViewController.cancelButtonColor = Gen.Colors.white.color
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetButtonHidden = true
        cropViewController.customAspectRatio = CGSize(width: 300, height: 300)
        cropViewController.aspectRatioPickerButtonHidden = true
        let emotionCoverImage = self.getEmotionCoverImage(self.reactor?.emotion ?? .fun)
        let emotionCoverImageView: UIImageView = UIImageView()
        emotionCoverImageView.contentMode = .scaleToFill
        emotionCoverImageView.image = emotionCoverImage
        cropViewController.cropView.insertSubview(emotionCoverImageView, belowSubview: cropViewController.cropView.gridOverlayView)
        emotionCoverImageView.snp.makeConstraints { (make) in
            let offset: CGFloat = UIDevice.current.hasNotch ? 24 : 0
            make.centerY.equalTo(cropViewController.cropView.snp.centerY).offset(offset)
            make.leading.equalTo(cropViewController.cropView.snp.leading).offset(12)
            make.trailing.equalTo(cropViewController.cropView.snp.trailing).offset(-12)
            make.height.equalTo(UIScreen.main.bounds.width - 24)
        }
        self.present(cropViewController, animated: true, completion: nil)
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

extension ImageSelectViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        DispatchQueue.main.async { [weak self] in
            cropViewController.dismiss(animated: true, completion: { [weak self] in
                self?.reactor?.action.onNext(.imageCropDone(image))
            })
        }
    }
}
