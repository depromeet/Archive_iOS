//
//  ContentsRecordReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import RxSwift
import ReactorKit

class ContentsRecordReactor: Reactor {
    // MARK: private property
    
    private let model: ContentsRecordModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    
    // MARK: lifeCycle
    
    init(model: ContentsRecordModelProtocol) {
        self.model = model
    }
    
    enum Action {
        case setContentsDate(_ dateStr: String)
        case setContentsTitle(_ title: String)
        case setFriends(_ friends: String)
    }
    
    enum Mutation {
        case setContentsDate(String)
        case setContentsTitle(String)
        case setFriends([String])
        case checkIsAllContentsSetted
    }
    
    struct State {
        var contentsDate: String = ""
        var contentsTitle: String = ""
        var friends: [String] = [String]()
        var isAllContentsSetted: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setContentsDate(date: let dateStr):
            return Observable.concat([
                Observable.just(Mutation.setContentsDate(dateStr)),
                Observable.just(Mutation.checkIsAllContentsSetted)
            ])
        case .setContentsTitle(title: let title):
            return Observable.concat([
                Observable.just(Mutation.setContentsTitle(title)),
                Observable.just(Mutation.checkIsAllContentsSetted)
            ])
        case .setFriends(value: let friendsStr):
            let friends = convertStrFriendsToFriendsArray(friendsStr)
            return Observable.concat([
                Observable.just(Mutation.setFriends(friends)),
                Observable.just(Mutation.checkIsAllContentsSetted)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setContentsDate(let dateStr):
            newState.contentsDate = dateStr
        case .setContentsTitle(let title):
            newState.contentsTitle = title
        case .setFriends(let friends):
            newState.friends = friends
        case .checkIsAllContentsSetted:
            newState.isAllContentsSetted = checkIsAllContentsSetted()
        }
        return newState
    }
    
    // MARK: private function
    
    private func convertStrFriendsToFriendsArray(_ friendsStr: String) -> [String] {
        var returnArr: [String] = [String]()
        
        let splited = friendsStr.split(separator: ",")
        for item in splited {
            returnArr.append(String(item))
        }
        
        return returnArr
    }
    
    private func checkIsAllContentsSetted() -> Bool {
        var returnValue: Bool = false
        if self.currentState.friends.count > 0 &&
            self.currentState.contentsTitle != "" &&
            self.currentState.contentsDate != "" {
            returnValue = true
        }
        return returnValue
    }
    
    // MARK: internal function
}
