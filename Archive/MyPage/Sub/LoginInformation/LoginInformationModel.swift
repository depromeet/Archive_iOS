//
//  LoginInformationModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import UIKit


protocol LoginInformationModelProtocol {
    var loginInfo: String { get } // TODO: 로그인 정보 객체타입 클래스 or 프로토콜로 바뀌어야함. 우선 String타입으로 임시로 박아놓음
    var cardCnt: Int { get }
}

class LoginInformationModel: LoginInformationModelProtocol {
    
    // MARK: private property
    
    // MARK: internal property
    
    var loginInfo: String
    var cardCnt: Int
    
    // MARK: lifeCycle
    
    init(loginInfo: String, cardCount: Int) {
        self.loginInfo = loginInfo
        self.cardCnt = cardCount
    }
    // MARK: private function
    
    // MARK: internal function
    
}
