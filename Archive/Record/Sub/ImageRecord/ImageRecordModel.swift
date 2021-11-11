//
//  ImageRecordModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit

protocol ImageRecordModelProtocol {
    var imageInfo: [ImageInfo] { get set }
}

class ImageRecordModel: ImageRecordModelProtocol {
    
    // MARK: outlet
    
    // MARK: private property
    
    // MARK: property
    
    var imageInfo: [ImageInfo] = []
    
    // MARK: lifeCycle
    
    init() {
        
    }
    
    // MARK: private func
    
    // MARK: func
    
    // MARK: action
}

struct ImageInfo: Equatable {
    var image: UIImage
    var backgroundColor: UIColor
    var contents: String?
}
