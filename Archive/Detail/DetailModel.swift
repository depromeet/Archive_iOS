//
//  DetailModel.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit

protocol DetailModelProtocol: AnyObject {
    var recordData: RecordData { get }
}

class DetailModel: DetailModelProtocol {
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    let recordData: RecordData
    
    // MARK: lifeCycle
    
    init(recordData: RecordData) {
        self.recordData = recordData
    }
    
    // MARK: private function
    
    // MARK: internal function
    
    // MARK: action
    
}
