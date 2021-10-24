//
//  LoginInformationReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import ReactorKit
import RxSwift
import RxRelay
import RxFlow

class LoginInformationReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: LoginInformationModelProtocol
    private let type: LoginType
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState = State()
    
    // MARK: lifeCycle
    
    init(model: LoginInformationModelProtocol, type: LoginType) {
        self.model = model
        self.type = type
    }
    
    enum Action {
        case refreshLoginType
        case moveWithdrawalPage
        case logout
    }
    
    enum Mutation {
        case setLoginType(LoginType)
        case loggedOut
    }
    
    struct State {
        var type: LoginType = .kakao
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshLoginType:
            let type = self.type
            return .just(.setLoginType(type))
        case .moveWithdrawalPage:
            steps.accept(ArchiveStep.withdrawalIsRequired(self.model.cardCnt))
            return .empty()
        case .logout:
            // TODO: 로그아웃 처리
            return .just(.loggedOut)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoginType(let type):
            newState.type = type
        case .loggedOut:
            break
        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
