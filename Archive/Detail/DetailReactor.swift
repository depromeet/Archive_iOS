//
//  DetailReactor.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit
import ReactorKit
import RxRelay
import RxFlow

class DetailReactor: Reactor, Stepper {
    
    // MARK: private property
    
    private var model: DetailModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    
    // MARK: lifeCycle
    
    init(model: DetailModelProtocol) {
        self.model = model
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .record:
//            record()
//            return .empty()
//        case .setRecordIsDone(let isDone):
//            return .just(.setRecordIsDone(isDone))
//        case .cancel:
//            return .empty()
//        case .moveToCompleteView:
//            let thumbnail: UIImage = self.model.thumbnailImage
//            let emotion: Emotion = self.model.emotion
//            let info: ContentsRecordModelData = self.model.contents
//            steps.accept(ArchiveStep.recordUploadIsComplete(thumbnail, emotion, info))
//            return .empty()
//        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
//        switch mutation {
//        case .setRecordIsDone(let isDone):
//            newState.recordIsDone = isDone
//        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
