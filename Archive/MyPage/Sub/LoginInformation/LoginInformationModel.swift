//
//  LoginInformationModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import UIKit


protocol LoginInformationModelProtocol {
    var email: String { get }
    var cardCnt: Int { get }
}

class LoginInformationModel: LoginInformationModelProtocol {
    
    // MARK: private property
    
    // MARK: internal property
    
    var email: String
    var cardCnt: Int
    
    // MARK: lifeCycle
    
    init(email: String, cardCount: Int) {
        self.email = email
        self.cardCnt = cardCount
    }
    // MARK: private function
    
    // MARK: internal function
    
}
