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
import Moya

final class HomeReactor: Reactor, Stepper {
    
    // MARK: private property
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState: State = State()
    
    // MARK: lifeCycle
    
    enum Action {
        case getMyArchives
        case showDetail(Int)
        case addArchive
        case showMyPage(Int)
    }
    
    enum Mutation {
        case setIsLoading(Bool)
        case setIsShimmering(Bool)
        case setMyArchivesData(Data?)
    }
    
    struct State {
        var archives: [ArchiveInfo] = [ArchiveInfo]()
        var isLoading: Bool = false
        var isShimmering: Bool = false
        var arvhivesCount: Int = 0
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getMyArchives:
            return Observable.concat([
                Observable.just(.setIsShimmering(true)),
                self.getArchives().map { [weak self] result in
                    switch result {
                    case .success(let data):
                        return .setMyArchivesData(data)
                    case .failure(let err):
                        print("err: \(err.localizedDescription)")
                        guard let code = (err as? MoyaError)?.response?.statusCode else { return .setMyArchivesData(nil) }
                        if code == 403 {
                            UserDefaultManager.shared.setLoginToken("")
                            self?.steps.accept(ArchiveStep.logout)
                            return .setMyArchivesData(nil)
                        } else {
                            return .setMyArchivesData(nil)
                        }
                    }
                },
                Observable.just(.setIsShimmering(false))
            ])
        case .showDetail(let index):
            return Observable.concat([
                Observable.just(.setIsLoading(true)),
                self.getDetailArchiveInfo(id: "\(currentState.archives[index].archiveId)").map { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.moveToDetail(data: data, index: index)
                    case .failure(let err):
                        print("err: \(err.localizedDescription)")
                    }
                    return .setIsLoading(false)
                }
            ])
        case .addArchive:
            self.steps.accept(ArchiveStep.recordIsRequired)
            return .empty()
        case .showMyPage(let archiveCnt):
            self.steps.accept(ArchiveStep.myPageIsRequired(archiveCnt))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsShimmering(let isShimmering):
            newState.isShimmering = isShimmering
        case .setIsLoading(let isLoading):
            newState.isLoading = isLoading
        case .setMyArchivesData(let data):
            if let data = data {
                let infosTuple = convertDataToArchivesInfos(data: data)
                let infos = infosTuple.0
                let infosTotalCount = infosTuple.1
                newState.archives = infos.reversed()
                newState.arvhivesCount = infosTotalCount
            }
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
    
    private func getDetailArchiveInfo(id: String) -> Observable<Result<Data, Error>> {
        let provider = ArchiveProvider.shared.provider
        return provider.rx.request(.getDetailArchive(archiveId: id), callbackQueue: DispatchQueue.global())
            .asObservable()
            .map { result in
                return .success(result.data)
            }
            .catch { err in
                .just(.failure(err))
            }
    }
    
    private func convertDataToArchivesInfos(data: Data) -> ([ArchiveInfo], Int) {
        var items: [ArchiveInfo] = [ArchiveInfo]()
        var itemsCount = 0
        if let jsonData: JSON = try? JSON.init(data: data) {
            itemsCount = jsonData["archiveCount"].intValue
            let archivesJson = jsonData["archives"]
            for item in archivesJson {
                if let itemData = try? item.1.rawData() {
                    if let info = ArchiveInfo.fromJson(jsonData: itemData) {
                        items.append(info)
                    }
                }
            }
        }
        return (items, itemsCount)
    }
    
    private func moveToDetail(data: Data, index: Int) {
        if let info = ArchiveDetailInfo.fromJson(jsonData: data) {
            DispatchQueue.main.async { [weak self] in
                self?.steps.accept(ArchiveStep.detailIsRequired(info, index))
            }
        }
    }
    
    // MARK: internal function
    
    

}
