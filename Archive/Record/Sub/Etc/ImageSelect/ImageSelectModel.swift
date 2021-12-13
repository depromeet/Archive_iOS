//
//  ImageSelectModel.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit

protocol ImageSelectModelProtocol {
    var images: [UIImage]? { get set }
    var coverImage: UIImage? { get set }
}

class ImageSelectModel: ImageSelectModelProtocol {
    
    // MARK: private property
    
    // MARK: internal property
    
    var images: [UIImage]?
    var coverImage: UIImage?
    
    // MARK: lifeCycle
    
    // MARK: private function
    
    // MARK: internal function
    
}
