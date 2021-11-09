//
//  RecordImageCollectionViewCell.swift
//  Archive
//
//  Created by hanwe lee on 2021/11/01.
//

import UIKit
import UIImageColors

protocol RecordImageCollectionViewCellDelegate: AnyObject {
    func imageCrop(image: UIImage, index: Int)
}

class RecordImageCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: outlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: private property
    
    // MARK: property
    
    var imageInfo: ImageInfo? {
        didSet {
            guard let info = self.imageInfo else { return }
            DispatchQueue.main.async { [weak self] in
                self?.mainImageView.image = info.image
                self?.mainContainerView.backgroundColor = info.backgroundColor
            }
        }
    }
    
    var emotion: Emotion? {
        didSet {
            guard let emotion = self.emotion else { return }
            DispatchQueue.main.async { [weak self] in
                self?.setNewEmotion(emotion)
            }
        }
    }
    
    var index: Int = -1
    
    weak var delegate: RecordImageCollectionViewCellDelegate?
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private func
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear
    }
    
    private func setNewEmotion(_ emotion: Emotion) {
        
    }
    
    // MARK: func
    
    // MARK: action
    @IBAction func imageCropAction(_ sender: Any) {
        guard let image = self.mainImageView.image else { return }
        self.delegate?.imageCrop(image: image, index: self.index)
    }
    
}
