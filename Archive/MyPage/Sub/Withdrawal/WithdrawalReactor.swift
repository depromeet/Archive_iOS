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
        case cardCnt
        case completion
        case withrawal
    }
    
    enum Mutation {
        case setCardCnt(Int)
        case withrawal
    }
    
    struct State {
        var cardCnt: Int = 0
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cardCnt:
            let cnt = model.cardCount
            return .just(.setCardCnt(cnt))
        case .completion:
            steps.accept(ArchiveStep.withdrawalIsComplete)
            return .empty()
        case .withrawal:
            // TODO: 탈퇴처리
            return .just(.withrawal)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCardCnt(let cardCnt):
            newState.cardCnt = cardCnt
        case .withrawal:
            break
        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
