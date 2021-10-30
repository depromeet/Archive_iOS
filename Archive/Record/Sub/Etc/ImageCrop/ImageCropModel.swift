//
//  ImageCropModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit

protocol ImageCropModelProtocol: AnyObject {
    var thumbnailImage: UIImage { get }
}

class ImageCropModel: ImageCropModelProtocol {
    
    // MARK: private property
    
    // MARK: internal property
    
    var thumbnailImage: UIImage
    
    // MARK: lifeCycle
    
    init(thumbnailImage: UIImage) {
        self.thumbnailImage = thumbnailImage
    }
    
    // MARK: private function
    
    // MARK: internal function
    
}
