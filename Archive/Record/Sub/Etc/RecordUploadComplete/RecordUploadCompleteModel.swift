//
//  RecordUploadCompleteModel.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit

protocol RecordUploadCompleteModelProtocol: AnyObject {
    var thumbnail: UIImage { get set }
    var emotion: Emotion { get set }
    var contentsInfo: ContentsRecordModelData { get set }
}

class RecordUploadCompleteModel: RecordUploadCompleteModelProtocol {
    
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    var thumbnail: UIImage
    var emotion: Emotion
    var contentsInfo: ContentsRecordModelData
    
    // MARK: lifeCycle
    
    init(thumbnail: UIImage, emotion: Emotion, contentsInfo: ContentsRecordModelData) {
        self.thumbnail = thumbnail
        self.emotion = emotion
        self.contentsInfo = contentsInfo
    }
    
    // MARK: private function
    
    // MARK: internal function
    
    // MARK: action
    
}
