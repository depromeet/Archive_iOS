//
//  RecordReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import RxSwift
import RxRelay
import RxFlow
import ReactorKit
import Photos

class RecordReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: RecordModelProtocol
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState = State()
    let moveToConfig: PublishSubject<Void>
    let error: PublishSubject<String>
    
    // MARK: lifeCycle
    
    init(model: RecordModelProtocol) {
        self.model = model
        self.moveToConfig = .init()
        self.error = .init()
    }
    
    enum Action {
        case moveToSelectEmotion
        case setEmotion(Emotion)
        case moveToPhotoSelet
    }
    
    enum Mutation {
        case setEmotion(Emotion)
    }
    
    struct State {
        var currentEmotion: Emotion?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToSelectEmotion:
            steps.accept(ArchiveStep.recordEmotionEditIsRequired)
            return .empty()
        case .setEmotion(let emotion):
            return .just(.setEmotion(emotion))
        case .moveToPhotoSelet:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEmotion(let emotion):
            newState.currentEmotion = emotion
        }
        return newState
    }
    
    // MARK: private function
    
    private func checkPhotoAuth() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            break
        case .denied, .restricted :
            self.moveToConfig.onNext(())
        case .notDetermined:
            requestPhotoAuth()
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private func requestPhotoAuth() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] (status) in
                switch status {
                case .authorized:
                    // move to photo
                    break
                case .denied, .restricted, .notDetermined, .limited:
                    self?.error.onNext("티켓 기록 사진을 선택하려면 Archive가 사진 라이브러리 접근권한이 필요합니다.")
                @unknown default:
                    break
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                switch status {
                case .authorized:
                    // move to photo
                    break
                case .denied, .restricted, .notDetermined, .limited:
                    self?.error.onNext("티켓 기록 사진을 선택하려면 Archive가 사진 라이브러리 접근권한이 필요합니다.")
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: internal function
}
