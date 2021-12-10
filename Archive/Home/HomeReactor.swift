//
//  HomeReactor.swift
//  Archive
//
//  Created by TTOzzi on 2021/11/13.
//

import ReactorKit
import RxRelay
import RxFlow

final class HomeReactor: Reactor, Stepper {
    
    // MARK: private property
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState: State = State()
    
    // MARK: lifeCycle
    
    init() { }
    
    enum Action {
        
    }
    
    struct State {
        
    }
    
    // MARK: private function
    
    // MARK: internal function
    
    

}
