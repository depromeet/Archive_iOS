//
//  DetailContentsCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit
import Kingfisher

class DetailContentsCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: outlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: private property
    
    // MARK: property
    
    var imageInfo: RecordImageData? {
        didSet {
            guard let info = self.imageInfo else { return }
            DispatchQueue.main.async { [weak self] in
                self?.mainContainerView.backgroundColor = info.backgroundColor.colorWithHexString()
                self?.mainImageView.kf.setImage(with: URL(string: info.image),
                                               placeholder: nil,
                                               options: [.cacheMemoryOnly],
                                               completionHandler: { [weak self] _ in
                    self?.mainImageView.fadeIn(duration: 0.1, completeHandler: nil)
                })
            }
        }
    }
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private func
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear
    }
    
    // MARK: func
    
    // MARK: action
    
}
