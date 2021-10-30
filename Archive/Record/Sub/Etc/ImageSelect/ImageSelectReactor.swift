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

class ImageSelectReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: ImageSelectModel
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    
    // MARK: lifeCycle
    
    init(model: ImageSelectModel) {
        self.model = model
    }
    
    enum Action {
//        case select(Emotion)
//        case completeEmotionEdit
    }
    
    enum Mutation {
//        case setEmotion(Emotion)
    }
    
    struct State {
//        var currentEmotion: Emotion = .pleasant
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .select(let emotion):
//            return .just(.setEmotion(emotion))
//        case .completeEmotionEdit:
//            steps.accept(ArchiveStep.recordEmotionEditIsComplete(self.currentState.currentEmotion))
//            return .empty()
//        }
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
//        switch mutation {
//        case .setEmotion(let emotion):
//            newState.currentEmotion = emotion
//        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
