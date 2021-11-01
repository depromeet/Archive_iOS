//
//  RecordCardCollectionViewCell.swift
//  Archive
//
//  Created by hanwe lee on 2021/11/01.
//

import UIKit

class RecordCardCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: outlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var emotionImageView: UIImageView!
    
    // MARK: private property
    
    // MARK: property
    
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
        self.mainImageView.contentMode = .scaleAspectFill
        self.emotionImageView.contentMode = .scaleAspectFill
    }
    
    private func setNewEmotion(_ emotion: Emotion) {
        switch emotion {
        case .fun:
            self.emotionImageView.image = Gen.Images.colorFun.image
            self.mainContainerView.backgroundColor = Gen.Colors.funYellow.color
        case .impressive:
            self.emotionImageView.image = Gen.Images.colorImpressive.image
            self.mainContainerView.backgroundColor = Gen.Colors.impressiveGreen.color
        case .pleasant:
            self.emotionImageView.image = Gen.Images.colorPleasant.image
            self.mainContainerView.backgroundColor = Gen.Colors.pleasantRed.color
        case .splendid:
            self.emotionImageView.image = Gen.Images.colorSplendid.image
            self.mainContainerView.backgroundColor = Gen.Colors.splendidBlue.color
        case .wonderful:
            self.emotionImageView.image = Gen.Images.colorWonderful.image
            self.mainContainerView.backgroundColor = Gen.Colors.wonderfulPurple.color
        }
    }
    
    // MARK: func
    
    // MARK: action

}
