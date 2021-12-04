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
        self.action.onNext(.setDetailData(self.model.recordData))
    }
    
    enum Action {
        case setDetailData(RecordData)
    }
    
    enum Mutation {
        case setDetailData(RecordData)
    }
    
    struct State {
        var detailData: RecordData?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setDetailData(let data):
            return .just(.setDetailData(data))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDetailData(let data):
            newState.detailData = data
        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
