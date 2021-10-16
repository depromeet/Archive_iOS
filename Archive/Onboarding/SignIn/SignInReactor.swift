//
//  SignInReactor.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/02.
//

import ReactorKit
import RxSwift
import RxRelay
import RxFlow

final class SignInReactor: Reactor, Stepper {
    
    enum Action {
        case idInput(text: String)
        case passwordInput(text: String)
        case signIn
        case signUp
    }
    
    enum Mutation {
        case setID(String)
        case setPassword(String)
        case setValidation(Bool)
    }
    
    struct State {
        var id: String = ""
        var password: String = ""
        var isEnableSignIn: Bool = false
    }
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    private let validator: SignInValidator
    
    init(validator: SignInValidator) {
        self.validator = validator
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .idInput(id):
            let isValid = validator.isEnableSignIn(id: id, password: currentState.password)
            return Observable.from([
                .setID(id),
                .setValidation(isValid)
            ])
            
        case let .passwordInput(password):
            let isValid = validator.isEnableSignIn(id: currentState.id, password: password)
            return Observable.from([
                .setPassword(password),
                .setValidation(isValid)
            ])
            
        case .signIn:
            // TODO: 자체 로그인 로직
            return .empty()
            
        case .signUp:
            steps.accept(ArchiveStep.termsAgreementIsRequired)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setID(id):
            newState.id = id
            
        case let .setPassword(password):
            newState.password = password
            
        case let.setValidation(isEnableSignIn):
            newState.isEnableSignIn = isEnableSignIn
        }
        return newState
    }
}
