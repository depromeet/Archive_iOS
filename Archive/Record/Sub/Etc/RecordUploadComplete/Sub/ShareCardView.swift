//
//  ShareCardView.swift
//  Archive
//
//  Created by hanwe on 2021/11/17.
//

import UIKit

class ShareCardView: UIView, NibIdentifiable {
    // MARK: IBOutlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailCoverImageView: UIImageView!
    
    // MARK: private property
    
    // MARK: internal property
    
    class func instance() -> ShareCardView? {
        return nib.instantiate(withOwner: nil, options: nil).first as? ShareCardView
    }
    
    var topBackgroundColor: UIColor = .clear
    var bottomBackgroundColor: UIColor = .clear
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.mainContainerView.backgroundColor = .clear
        self.bottomContainerView.backgroundColor = Gen.Colors.white.color
        self.eventNameLabel.font = .fonts(.header3)
        self.eventNameLabel.textColor = Gen.Colors.black.color
        self.dateLabel.font = .fonts(.subTitle)
        self.dateLabel.textColor = Gen.Colors.black.color
        self.emotionLabel.font = .fonts(.subTitle)
        self.emotionLabel.textColor = Gen.Colors.white.color
    }
    
    // MARK: internal function
    
    func setInfoData(emotion: Emotion, thumbnailImage: UIImage, eventName: String, date: String) {
        switch emotion {
        case .fun:
            self.emotionImageView.image = Gen.Images.typeFunNo.image
            self.thumbnailCoverImageView.image = Gen.Images.colorFun.image
            self.topContainerView.backgroundColor = Gen.Colors.funYellow.color
            self.topBackgroundColor = Gen.Colors.funYellowDarken.color
            self.bottomBackgroundColor = Gen.Colors.funYellow.color
            self.emotionLabel.text = "재미있는"
        case .impressive:
            self.emotionImageView.image = Gen.Images.typeImpressiveNo.image
            self.thumbnailCoverImageView.image = Gen.Images.colorImpressive.image
            self.topContainerView.backgroundColor = Gen.Colors.impressiveGreen.color
            self.topBackgroundColor = Gen.Colors.impressiveGreenDarken.color
            self.bottomBackgroundColor = Gen.Colors.impressiveGreen.color
            self.emotionLabel.text = "인상적인"
        case .pleasant:
            self.emotionImageView.image = Gen.Images.typePleasantNo.image
            self.thumbnailCoverImageView.image = Gen.Images.colorPleasant.image
            self.topContainerView.backgroundColor = Gen.Colors.pleasantRed.color
            self.topBackgroundColor = Gen.Colors.pleasantRedDarken.color
            self.bottomBackgroundColor = Gen.Colors.pleasantRed.color
            self.emotionLabel.text = "기분좋은"
        case .splendid:
            self.emotionImageView.image = Gen.Images.typeSplendidNo.image
            self.thumbnailCoverImageView.image = Gen.Images.colorSplendid.image
            self.topContainerView.backgroundColor = Gen.Colors.splendidBlue.color
            self.topBackgroundColor = Gen.Colors.splendidBlueDarken.color
            self.bottomBackgroundColor = Gen.Colors.splendidBlue.color
            self.emotionLabel.text = "아름다운"
        case .wonderful:
            self.emotionImageView.image = Gen.Images.typeWonderfulNo.image
            self.thumbnailCoverImageView.image = Gen.Images.colorWonderful.image
            self.topContainerView.backgroundColor = Gen.Colors.wonderfulPurple.color
            self.topBackgroundColor = Gen.Colors.wonderfulPurpleDarken.color
            self.bottomBackgroundColor = Gen.Colors.wonderfulPurple.color
            self.emotionLabel.text = "경이로운"
        }
        self.thumbnailImageView.image = thumbnailImage
        self.eventNameLabel.text = eventName
        self.dateLabel.text = date
    }
    
    // MARK: action
    
}
