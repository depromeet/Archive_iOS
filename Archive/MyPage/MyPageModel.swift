//
//  MyPageModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/21.
//

import UIKit

protocol MyPageModelProtocol {
    var cardCount: Int { get }
}

class MyPageModel: MyPageModelProtocol {
    // MARK: private property
    
    // MARK: internal property
    var cardCount: Int
    
    // MARK: lifeCycle
    
    init(cardCount: Int) {
        self.cardCount = cardCount
    }
    
    // MARK: private function
    
    // MARK: internal function
}
