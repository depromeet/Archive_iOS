//
//  RecordImageCollectionViewCell.swift
//  Archive
//
//  Created by hanwe lee on 2021/11/01.
//

import UIKit
import UIImageColors

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
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private func
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear
//        self.mainImageView.contentMode = 
    }
    
    private func setNewEmotion(_ emotion: Emotion) {
//        switch emotion {
//        case .fun:
//            self.mainContainerView.backgroundColor = Gen.Colors.funYellow.color
//        case .impressive:
//            self.mainContainerView.backgroundColor = Gen.Colors.impressiveGreen.color
//        case .pleasant:
//            self.mainContainerView.backgroundColor = Gen.Colors.pleasantRed.color
//        case .splendid:
//            self.mainContainerView.backgroundColor = Gen.Colors.splendidBlue.color
//        case .wonderful:
//            self.mainContainerView.backgroundColor = Gen.Colors.wonderfulPurple.color
//        }
//        self.mainContainerView.backgroundColor = self.mainImageView.image?.getColors()?.background
    }
    
    // MARK: func
    
    // MARK: action

}
