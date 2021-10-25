//
//  ImageRecordModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit

protocol ImageRecordModelProtocol {
    var images: [UIImage] { get }
}

class ImageRecordModel: ImageRecordModelProtocol {
    
    // MARK: outlet
    
    // MARK: private property
    
    // MARK: property
    
    var images: [UIImage]
    
    // MARK: lifeCycle
    
    init(images: [UIImage]) {
        self.images = images
    }
    
    // MARK: private func
    
    // MARK: func
    
    // MARK: action
}
