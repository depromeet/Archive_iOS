//
//  ImageSelectReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import RxSwift
import ReactorKit
import RxRelay
import RxFlow
import Photos
import UIKit

class ImageSelectReactor: Reactor, Stepper {
    // MARK: private property
    
    private var model: ImageSelectModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    var isLoading: PublishSubject<Bool>
    var presentCrop: PublishSubject<UIImage>
    var emotion: Emotion
    
    // MARK: lifeCycle
    
    init(model: ImageSelectModel, emotion: Emotion) {
        self.model = model
        self.isLoading = .init()
        self.presentCrop = .init()
        self.emotion = emotion
    }
    
    enum Action {
        case setImageInfos([PHAsset: PhotoFromAlbumModel])
        case setSelectedImageInfo(PHAsset)
        case confirm
        case imageCropDone(UIImage)
    }
    
    enum Mutation {
        case setImageInfos([PHAsset: PhotoFromAlbumModel])
        case setSelectedImageInfo(PHAsset)
    }
    
    struct State {
        var imageInfos: [PHAsset: PhotoFromAlbumModel] = [PHAsset: PhotoFromAlbumModel]()
        var selectedImageInfo: PHAsset?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setImageInfos(let imageInfos):
            return .just(.setImageInfos(imageInfos))
        case .setSelectedImageInfo(let info):
            return .just(.setSelectedImageInfo(info))
        case .confirm:
            confirm()
            return .empty()
        case .imageCropDone(let image):
            self.model.coverImage = image
            steps.accept(ArchiveStep.recordImageSelectIsComplete(model.coverImage ?? UIImage(), model.images ?? [UIImage]()))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImageInfos(let infos):
            newState.imageInfos = infos
        case .setSelectedImageInfo(let info):
            newState.selectedImageInfo = info
        }
        return newState
    }
    
    // MARK: private function
    
    private func confirm() {
        self.isLoading.onNext(true)
        if self.currentState.imageInfos.count == 0 {
            self.isLoading.onNext(false)
            return
        }
        selectedAssetToImage { [weak self] images in
            self?.isLoading.onNext(false)
            var images = images
            if images.count == 0 { return }
            let thumbnailImage: UIImage = images.first!
            images.removeFirst()
            self?.model.images = images
            self?.presentCrop.onNext(thumbnailImage)
        }
    }
    
    private func selectedAssetToImage(comletion: @escaping ([UIImage]) -> Void) {
        let selectedItems = self.currentState.imageInfos
        let allKeys = selectedItems.keys
        var infos: [PhotoFromAlbumModel] = [PhotoFromAlbumModel]()
        for key in allKeys {
            if let item = selectedItems[key] {
                infos.append(item)
            }
        }
        infos.sort(by: { $0.sequenceNum < $1.sequenceNum })
        var assets: [PHAsset] = [PHAsset]()
        for item in infos {
            guard let asset = item.asset else { continue }
            assets.append(asset)
        }
        phAssetToImages(assets, ImageSize: CGSize(width: 300, height: 300), completion: comletion)
    }
    
    private func phAssetToImages(_ assets: [PHAsset], ImageSize: CGSize, completion: @escaping ([UIImage]) -> Void) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var resultImages: [UIImage] = [UIImage]()
        for item in assets {
            manager.requestImage(for: item, targetSize: ImageSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
                if result != nil {
                    resultImages.append(result!)
                }
            })
        }
        completion(resultImages)
    }
    
    // MARK: internal function
}
