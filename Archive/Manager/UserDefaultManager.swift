//
//  UserDefaultManager.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit

class UserDefaultManager: NSObject {
    
    enum UserDefaultInfoType: String {
        case loginToken
    }
    
    // MARK: private property
    
    private let manager = UserDefaults.standard
    lazy private(set) var isLoggedIn = getInfo(.loginToken) == "" ? false : true
    
    // MARK: internal property
    
    static let shared: UserDefaultManager = {
        let instance = UserDefaultManager()
        return instance
    }()
    
    // MARK: lifeCycle
    
    // MARK: private function
    
    // MARK: internal function
    
    func setLoginToken(_ token: String) {
        self.manager.set(token, forKey: UserDefaultInfoType.loginToken.rawValue)
    }
    
    func getInfo(_ type: UserDefaultManager.UserDefaultInfoType) -> String {
        switch type {
        case .loginToken:
            return (manager.object(forKey: UserDefaultInfoType.loginToken.rawValue) as? String) ?? ""
        }
    }
    
    func removeInfo(_ type: UserDefaultManager.UserDefaultInfoType) {
        switch type {
        case .loginToken:
            manager.set(nil, forKey: UserDefaultInfoType.loginToken.rawValue)
        }
    }

}
