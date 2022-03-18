//
//  RecordUploadCompleteReactor.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit
import ReactorKit
import RxRelay
import RxFlow

class RecordUploadCompleteReactor: Reactor, Stepper {
    
    // MARK: private property
    
    private var model: RecordUploadCompleteModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    
    // MARK: lifeCycle
    
    init(model: RecordUploadCompleteModelProtocol) {
        self.model = model
    }
    
    enum Action {
        case close
        case shareToInstagram
        case saveToAlbum
    }
    
    enum Mutation {
        case setInstagramCardView(UIView)
        case setShareActivityController(UIActivityViewController)
    }
    
    struct State {
        var willSharedCarView: UIView?
        var shareActivityController: UIActivityViewController?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .close:
            steps.accept(ArchiveStep.recordComplete)
            return .empty()
        case .shareToInstagram:
            GAModule.sendEventLogToGA(.shareInstagramFromRegist)
            DispatchQueue.main.async { [weak self] in
                guard let cardView: ShareCardView = self?.makeCardView() else { return }
                InstagramStoryShareManager.shared.share(view: cardView, backgroundTopColor: cardView.topBackgroundColor, backgroundBottomColor: cardView.bottomBackgroundColor, completion: { _ in
                    
                }, failure: { _ in
                    
                })
            }
            return .empty()
        case .saveToAlbum:
            guard let cardView: ShareCardView = self.makeCardView() else { return .empty() }
            guard let activityViewController = CardShareManager.shared.share(view: cardView) else { return .empty() }
            return .just(.setShareActivityController(activityViewController))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setInstagramCardView(let carView):
            newState.willSharedCarView = carView
        case .setShareActivityController(let controller):
            newState.shareActivityController = controller
        }
        return newState
    }
    
    // MARK: private function
    
    private func makeCardView() -> ShareCardView? {
        guard let cardView: ShareCardView = ShareCardView.instance() else { return nil }
        cardView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.73)
        cardView.setInfoData(emotion: self.model.emotion, thumbnailImage: self.model.thumbnail, eventName: self.model.contentsInfo.title, date: self.model.contentsInfo.date)
        return cardView
    }
    
    // MARK: internal function
}
