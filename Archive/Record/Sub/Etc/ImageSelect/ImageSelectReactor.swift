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
import Moya

class ImageSelectReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: ImageSelectModel
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    var isLoading: PublishSubject<Bool>
    
    // MARK: lifeCycle
    
    init(model: ImageSelectModel) {
        self.model = model
        self.isLoading = .init()
    }
    
    enum Action {
        case setImageInfos([PHAsset: PhotoFromAlbumModel])
        case setSelectedImageInfo(PHAsset)
        case confirm
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
            self?.steps.accept(ArchiveStep.recordImageSelectIsComplete(images))
        }
    }
    
    private func selectedAssetToImage(comletion: @escaping ([UIImage]) -> Void) {
        let selectedItems = self.currentState.imageInfos
        var assets: [PHAsset] = [PHAsset]()
        let allKeys = selectedItems.keys
        for key in allKeys {
            if let item = selectedItems[key], let asset = item.asset {
                assets.append(asset)
            }
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
