//
//  RecordReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import RxSwift
import RxRelay
import RxFlow
import ReactorKit

class RecordReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: RecordModelProtocol
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState = State()
    
    // MARK: lifeCycle
    
    init(model: RecordModelProtocol) {
        self.model = model
    }
    
    enum Action {
        case moveToSelectEmotion
        case setEmotion(Emotion)
    }
    
    enum Mutation {
        case setEmotion(Emotion)
    }
    
    struct State {
        var currentEmotion: Emotion?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToSelectEmotion:
            steps.accept(ArchiveStep.recordEmotionEditIsRequired)
            return .empty()
        case .setEmotion(let emotion):
            return .just(.setEmotion(emotion))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEmotion(let emotion):
            newState.currentEmotion = emotion
        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
