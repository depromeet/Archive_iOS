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
        case record
        case setRecordIsDone(Bool)
        case cancel
        case moveToCompleteView
    }
    
    enum Mutation {
        case setRecordIsDone(Bool)
    }
    
    struct State {
        var recordIsDone: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .record:
            record()
            return .empty()
        case .setRecordIsDone(let isDone):
            return .just(.setRecordIsDone(isDone))
        case .cancel:
            return .empty()
        case .moveToCompleteView:
            let thumbnail: UIImage = self.model.thumbnailImage
            let emotion: Emotion = self.model.emotion
            let info: ContentsRecordModelData = self.model.contents
            steps.accept(ArchiveStep.recordUploadIsComplete(thumbnail, emotion, info))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRecordIsDone(let isDone):
            newState.recordIsDone = isDone
        }
        return newState
    }
    
    // MARK: private function
    
    private func record() {
        self.model.record {
            self.action.onNext(.setRecordIsDone(true))
            self.action.onNext(.moveToCompleteView)
        }
    }
    
    // MARK: internal function
}
