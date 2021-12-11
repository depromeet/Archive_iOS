//
//  DetailModel.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit

protocol DetailModelProtocol: AnyObject {
    var recordData: ArchiveDetailInfo { get }
}

class DetailModel: DetailModelProtocol {
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    let recordData: ArchiveDetailInfo
    
    // MARK: lifeCycle
    
    init(recordData: ArchiveDetailInfo) {
        self.recordData = recordData
    }
    
    // MARK: private function
    
    // MARK: internal function
    
    // MARK: action
    
}
