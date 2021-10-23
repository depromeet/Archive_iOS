//
//  WithdrawalModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

protocol WithdrawalModelProtocol {
    var cardCount: Int { get }
}

class WithdrawalModel: WithdrawalModelProtocol {
    var cardCount: Int
    
    // MARK: private property
    
    // MARK: internal property
    
    // MARK: lifeCycle
    
    init(cardCount: Int) {
        self.cardCount = cardCount
    }
    
    // MARK: private function
    
    // MARK: internal function

}
