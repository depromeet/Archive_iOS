//
//  RecordUploadReactor.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit
import ReactorKit
import RxRelay
import RxFlow

class RecordUploadReactor: Reactor, Stepper {
    
    // MARK: private property
    
    private var model: RecordUploadModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    
    // MARK: lifeCycle
    
    init(model: RecordUploadModelProtocol) {
        self.model = model
    }
    
    enum Action {
//        case setImageInfos([PHAsset: PhotoFromAlbumModel])
//        case setSelectedImageInfo(PHAsset)
//        case confirm
//        case imageCropDone(UIImage)
    }
    
    enum Mutation {
//        case setImageInfos([PHAsset: PhotoFromAlbumModel])
//        case setSelectedImageInfo(PHAsset)
    }
    
    struct State {
//        var imageInfos: [PHAsset: PhotoFromAlbumModel] = [PHAsset: PhotoFromAlbumModel]()
//        var selectedImageInfo: PHAsset?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .setImageInfos(let imageInfos):
//            return .just(.setImageInfos(imageInfos))
//        case .setSelectedImageInfo(let info):
//            return .just(.setSelectedImageInfo(info))
//        case .confirm:
//            confirm()
//            return .empty()
//        case .imageCropDone(let image):
//            self.model.coverImage = image
//            steps.accept(ArchiveStep.recordImageSelectIsComplete(model.coverImage ?? UIImage(), model.images ?? [UIImage]()))
//            return .empty()
//        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
//        switch mutation {
//        case .setImageInfos(let infos):
//            newState.imageInfos = infos
//        case .setSelectedImageInfo(let info):
//            newState.selectedImageInfo = info
//        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
