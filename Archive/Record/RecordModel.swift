//
//  RecordModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit

protocol RecordModelProtocol: AnyObject {
    var recordInfo: ContentsRecordModelData? { get set }
    var thumbnailImage: UIImage? { get set }
    var emotion: Emotion? { get set }
    var imageInfos: [ImageInfo]? { get set }
    
    func isAllDataSetted() -> Bool
}

class RecordModel: RecordModelProtocol {
    
    // MARK: private property
    
    // MARK: internal property
    
    var recordInfo: ContentsRecordModelData?
    var thumbnailImage: UIImage?
    var emotion: Emotion?
    var imageInfos: [ImageInfo]?
    
    // MARK: lifeCycle
    
    // MARK: private function
    
    // MARK: internal function
    
    func isAllDataSetted() -> Bool {
        if recordInfo != nil && thumbnailImage != nil && emotion != nil {
            return true
        } else {
            return false
        }
    }
    
}
