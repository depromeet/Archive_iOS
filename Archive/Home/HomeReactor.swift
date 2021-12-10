//
//  HomeReactor.swift
//  Archive
//
//  Created by TTOzzi on 2021/11/13.
//

import ReactorKit
import RxRelay
import RxFlow
import SwiftyJSON

final class HomeReactor: Reactor, Stepper {
    
    // MARK: private property
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState: State = State()
    
    // MARK: lifeCycle
    
    enum Action {
        case getMyArchives
    }
    
    enum Mutation {
        case setMyArchives([ArchiveInfo])
        case setIsLoading(Bool)
        case setIsShimmering(Bool)
    }
    
    struct State {
        var archives: [ArchiveInfo] = [ArchiveInfo]()
        var isLoading: Bool = false
        var isShimmering: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getMyArchives:
            return Observable.concat([
                Observable.just(.setIsShimmering(true)),
                self.getArchives().map { result in
                    switch result {
                    case .success(let data):
                        if let jsonData: JSON = try? JSON.init(data: data) {
                            let archivesJson = jsonData["archives"]
                            var items: [ArchiveInfo] = [ArchiveInfo]()
                            for item in archivesJson {
                                if let itemData = try? item.1.rawData() {
                                    if let info = ArchiveInfo.fromJson(jsonData: itemData) {
                                        items.append(info)
                                    }
                                }
                            }
                            return .setMyArchives(items)
                        } else {
                            return .setMyArchives([])
                        }
                    case .failure(let err):
                        print("err: \(err.localizedDescription)")
                        return .setMyArchives([])
                    }
                },
                Observable.just(.setIsShimmering(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMyArchives(let infos):
            newState.archives = infos
        case .setIsShimmering(let isShimmering):
            newState.isShimmering = isShimmering
        case .setIsLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
    
    // MARK: private function
    
    private func getArchives() -> Observable<Result<Data, Error>> {
        let provider = ArchiveProvider.shared.provider
        return provider.rx.request(.getArchives, callbackQueue: DispatchQueue.global())
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
