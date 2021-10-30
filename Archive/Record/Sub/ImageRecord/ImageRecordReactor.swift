//
//  ImageRecordReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import RxSwift
import ReactorKit

class ImageRecordReactor: Reactor {
    // MARK: private property
    
    private let model: ImageRecordModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    
    // MARK: lifeCycle
    
    init(model: ImageRecordModelProtocol) {
        self.model = model
    }
    
    enum Action {
        case setImages(_ images: [UIImage])
    }
    
    enum Mutation {
        case setImages(_ images: [UIImage])
    }
    
    struct State {
        var images: [UIImage] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setImages(let images):
            return .just(.setImages(images))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let images):
            newState.images = images
        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
