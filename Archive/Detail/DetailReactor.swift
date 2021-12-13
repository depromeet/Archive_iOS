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
        case setDetailData(ArchiveDetailInfo)
        case shareToInstagram
        case saveToAlbum
        case openShare(UIActivityViewController)
        case deleteArchive
    }
    
    enum Mutation {
        case setDetailData(ArchiveDetailInfo)
        case setShareActivityController(UIActivityViewController)
        case setIsDeletedArchive(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var detailData: ArchiveDetailInfo?
        var willSharedCarView: UIView?
        var shareActivityController: UIActivityViewController?
        var isDeletedArchive: Bool = false
        var isLoading: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setDetailData(let data):
            return .just(.setDetailData(data))
        case .shareToInstagram:
            DispatchQueue.main.async { [weak self] in
                self?.makeCardView(completion: { cardView in
                    InstagramStoryShareManager.shared.share(view: cardView, backgroundTopColor: cardView.topBackgroundColor, backgroundBottomColor: cardView.bottomBackgroundColor, completion: { _ in
                        
                    }, failure: { _ in
                        
                    })
                })
            }
            return .empty()
        case .saveToAlbum:
            DispatchQueue.main.async { [weak self] in
                self?.makeCardView(completion: { [weak self] cardView in
                    guard let activityViewController = CardShareManager.shared.share(view: cardView) else { return }
                    self?.action.onNext(.openShare(activityViewController))
                })
            }
            return .empty()
        case .openShare(let controller):
            return .just(.setShareActivityController(controller))
        case .deleteArchive:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.deleteArchive(archiveId: "\(self.currentState.detailData?.archiveId ?? 0)").map { result in
                    switch result {
                    case .success(_):
                        return .setIsDeletedArchive(true)
                    case .failure(_):
                        return .setIsDeletedArchive(false)
                    }
                },
                Observable.just(.setIsDeletedArchive(true)),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDetailData(let data):
            newState.detailData = data
        case .setShareActivityController(let controller):
            newState.shareActivityController = controller
        case .setIsDeletedArchive(let isDeleted):
            newState.isDeletedArchive = isDeleted
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
    
    func getIndex() -> Int {
        return self.model.index
    }
    
    // MARK: private function
    
    private func makeCardView(completion: @escaping (ShareCardView) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: (self?.model.recordData.mainImage)!)!) {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    guard let cardView: ShareCardView = ShareCardView.instance() else { return }
                    cardView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.73)
                    cardView.setInfoData(emotion: Emotion.fromString(self.model.recordData.emotion) ?? .fun, thumbnailImage: UIImage(data: data) ?? UIImage(), eventName: self.model.recordData.name, date: self.model.recordData.watchedOn)
                    completion(cardView)
                }
            } else {
                completion(ShareCardView())
            }
        }
    }
    
    private func deleteArchive(archiveId: String) -> Observable<Result<Data, Error>> {
        let archiveId: String = archiveId
        let provider = ArchiveProvider.shared.provider
        
        return provider.rx.request(.deleteArchive(archiveId: archiveId), callbackQueue: DispatchQueue.global())
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
