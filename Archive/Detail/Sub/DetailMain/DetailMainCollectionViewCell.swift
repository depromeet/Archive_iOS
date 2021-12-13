//
//  DetailMainCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/12/04.
//

import UIKit
import Kingfisher
import SnapKit

class DetailMainCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: outlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var emotionMiniImageView: UIImageView!
    @IBOutlet weak var emotionTitleLabel: UILabel!
    @IBOutlet weak var friendsMiniImageView: UIImageView!
    @IBOutlet weak var friendsMiniImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsMiniImageViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: private property
    
    // MARK: property
    
    var infoData: ArchiveDetailInfo? {
        didSet {
            guard let info = self.infoData else { return }
            DispatchQueue.main.async { [weak self] in
                if let emotion: Emotion = Emotion.fromString(info.emotion) {
                    self?.setNewEmotion(emotion)
                }
                self?.mainImageView.kf.setImage(with: URL(string: info.mainImage),
                                               placeholder: nil,
                                               options: [.cacheMemoryOnly],
                                               completionHandler: { [weak self] _ in
                    self?.mainImageView.fadeIn(duration: 0.1, completeHandler: nil)
                })
                if let friends = info.companions {
                    let extraWidth: CGFloat = (self?.friendsMiniImageViewLeadingConstraint.constant ?? 0) + (self?.friendsMiniImageViewWidthConstraint.constant ?? 0) + 10
                    if let friendsView = self?.makeFriendsView(list: friends, viewWidth: UIScreen.main.bounds.width - extraWidth) {
                        // TODO: 이거 만들어야함
                    }
                }
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
        self.emotionTitleLabel.font = .fonts(.subTitle)
        self.emotionTitleLabel.textColor = Gen.Colors.white.color
    }
    
    private func setNewEmotion(_ emotion: Emotion) {
        switch emotion {
        case .fun:
            self.emotionImageView.image = Gen.Images.colorFun.image
            self.mainContainerView.backgroundColor = Gen.Colors.funYellow.color
            self.emotionTitleLabel.text = "재미있는"
            self.emotionMiniImageView.image = Gen.Images.preFun.image
        case .impressive:
            self.emotionImageView.image = Gen.Images.colorImpressive.image
            self.mainContainerView.backgroundColor = Gen.Colors.impressiveGreen.color
            self.emotionTitleLabel.text = "인상적인"
            self.emotionMiniImageView.image = Gen.Images.preImpressive.image
        case .pleasant:
            self.emotionImageView.image = Gen.Images.colorPleasant.image
            self.mainContainerView.backgroundColor = Gen.Colors.pleasantRed.color
            self.emotionTitleLabel.text = "기분좋은"
            self.emotionMiniImageView.image = Gen.Images.prePleasant.image
        case .splendid:
            self.emotionImageView.image = Gen.Images.colorSplendid.image
            self.mainContainerView.backgroundColor = Gen.Colors.splendidBlue.color
            self.emotionTitleLabel.text = "아름다운"
            self.emotionMiniImageView.image = Gen.Images.preSplendid.image
        case .wonderful:
            self.emotionImageView.image = Gen.Images.colorWonderful.image
            self.mainContainerView.backgroundColor = Gen.Colors.wonderfulPurple.color
            self.emotionTitleLabel.text = "경이로운"
            self.emotionMiniImageView.image = Gen.Images.preWonderful.image
        }
    }
    
    private func makeFriendsView(list: [String], viewWidth: CGFloat) -> UIView {
        return UIView()
    }
    
    // MARK: func
    
    // MARK: action

}
