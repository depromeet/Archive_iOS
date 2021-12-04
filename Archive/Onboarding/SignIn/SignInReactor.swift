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
    var error: PublishSubject<String>
    var isLoading: PublishSubject<Bool>
    
    init(validator: SignInValidator) {
        self.validator = validator
        self.error = .init()
        self.isLoading = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .idInput(id):
            let isValid = validator.isEnableSignIn(id: id, password: currentState.password)
            return .from([.setID(id),
                          .setValidation(isValid)])
            
        case let .passwordInput(password):
            let isValid = validator.isEnableSignIn(id: currentState.id, password: password)
            return .from([.setPassword(password),
                          .setValidation(isValid)])
            
        case .signIn:
            loginEmail(eMail: self.currentState.id, password: self.currentState.password)
            // Todo 메인으로 이동
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
    
    private func loginEmail(eMail: String, password: String) {
        self.isLoading.onNext(true)
        let provider = ArchiveProvider.shared.provider
        let param = LoginEmailParam(email: eMail, password: password)
        provider.request(.loginEmail(param), completion: { [weak self] response in
            self?.isLoading.onNext(false)
            switch response {
            case .success(let response):
                guard let token: String = response.response?.headers["Authorization"] else {
                    self?.error.onNext("[오류] 토큰이 존재하지 않습니다.")
                    return
                }
                UserDefaultManager.shared.setLoginToken(token)
            case .failure(let err):
                print("err: \(err.localizedDescription)")
                self?.error.onNext("로그인 정보가 정확하지 않습니다.")
            }
        })
    }
}

struct LoginEmailParam: Encodable {
    var email: String
    var password: String
}
