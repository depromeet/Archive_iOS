//
//  ImageCropReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit
import ReactorKit
import RxRelay
import RxFlow

class ImageCropReactor: Reactor, Stepper {
    // MARK: private property
    
    private let model: ImageCropModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    
    // MARK: lifeCycle
    
    init(model: ImageCropModelProtocol) {
        self.model = model
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
    
    // MARK: private function
    
    // MARK: internal function
}
