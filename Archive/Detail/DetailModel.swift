//
//  DetailModel.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit

protocol DetailModelProtocol: AnyObject {
    var recordData: ArchiveDetailInfo { get }
    var index: Int { get }
}

class DetailModel: DetailModelProtocol {
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    let recordData: ArchiveDetailInfo
    var index: Int
    
    // MARK: lifeCycle
    
    init(recordData: ArchiveDetailInfo, index: Int) {
        self.recordData = recordData
        self.index = index
    }
    
    // MARK: private function
    
    // MARK: internal function
    
    // MARK: action
    
}
