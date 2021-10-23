//
//  WithdrawalReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import ReactorKit
import RxSwift
import RxRelay
import RxFlow

class WithdrawalReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: WithdrawalModelProtocol
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState = State()
    
    // MARK: lifeCycle
    
    init(model: WithdrawalModelProtocol) {
        self.model = model
    }
    
    enum Action {
//        case refreshLoginType
    }
    
    enum Mutation {
//        case setLoginType(LoginType)
    }
    
    struct State {
//        var type: LoginType = .kakao
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .refreshLoginType:
//            let type = self.type
//            return .just(.setLoginType(type))
//        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
//        switch mutation {
//        case .setLoginType(let type):
//            newState.type = type
//        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
