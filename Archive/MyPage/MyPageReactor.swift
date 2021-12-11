//
//  MyPageReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/21.
//

import ReactorKit
import RxSwift
import RxRelay
import RxFlow
import SwiftyJSON

class MyPageReactor: Reactor, Stepper {
    
    // MARK: private property
    
    private let model: MyPageModelProtocol
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState = State()
    
    // MARK: lifeCycle
    
    init(model: MyPageModelProtocol) {
        self.model = model
    }
    
    enum Action {
        case cardCnt
        case moveToLoginInfo
        case openTerms
        case openPrivacy
    }
    
    enum Mutation {
        case setCardCnt(Int)
        case setIsLoading(Bool)
    }
    
    struct State {
        var cardCnt: Int = 0
        var isLoading: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cardCnt:
            let cnt = model.cardCount
            return .just(.setCardCnt(cnt))
        case .moveToLoginInfo:
            return Observable.concat([
                Observable.just(.setIsLoading(true)),
                self.getMyUserInfo().map { [weak self] result in
                    switch result {
                    case .success(let data):
                        if let jsonData: JSON = try? JSON.init(data: data) {
                            let mailAddrStr = jsonData["mailAddress"].stringValue
                            self?.steps.accept(ArchiveStep.loginInfomationIsRequired(.eMail, mailAddrStr, self?.currentState.cardCnt ?? 0))
                        }
                    case .failure(let err):
                        print("err: \(err.localizedDescription)")
                    }
                    return .setIsLoading(false)
                }
            ])
        case .openTerms:
            openUseSafari("https://wise-icicle-d10.notion.site/8ad4c5884b814ff6a6330f1a6143c1e6")
            return .empty()
        case .openPrivacy:
            openUseSafari("https://wise-icicle-d10.notion.site/13ff403ad4e2402ca657fb20be31e4ae")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCardCnt(let cardCnt):
            newState.cardCnt = cardCnt
        case .setIsLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
    
    // MARK: private function
    
    private func openUseSafari(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func getMyUserInfo() -> Observable<Result<Data, Error>> {
        let provider = ArchiveProvider.shared.provider
        
        return provider.rx.request(.getCurrentUserInfo, callbackQueue: DispatchQueue.global())
            .asObservable()
            .map { result in
                return .success(result.data)
            }
            .catch { err in
                .just(.failure(err))
            }
    }
    
    // MARK: internal function
    

    

    
    
    
}
