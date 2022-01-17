//
//  CardRecordCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2022/01/08.
//

import UIKit

protocol CardRecordCollectionViewCellDelegate: AnyObject {
    func selectImageClicked()
    func selectEmotionClicked()
    func selectContentsClicked()
}

class CardRecordCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var navigationCoverView: UIView!
    
    @IBOutlet weak var cardContainerView: UIView!
    
    @IBOutlet weak var placeHolderContainerView: UIView!
    
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var emotionCoverView: UIImageView!
    @IBOutlet weak var addMainImageBtn: UIButton!
    
    @IBOutlet weak var selectEmotionContainerView: UIView!
    @IBOutlet weak var currentEmotionImageView: UIImageView!
    @IBOutlet weak var currentEmotionLabel: UILabel!
    
    @IBOutlet weak var contentsContainerView: UIView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var archiveNameLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
    
    // MARK: private property
    
    // MARK: internal property
    
    weak var delegate: CardRecordCollectionViewCellDelegate?
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.scrollContainerView.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.cardContainerView.backgroundColor = Gen.Colors.gray05.color
        self.placeHolderContainerView.backgroundColor = .clear
        self.placeHolderContainerView.isHidden = false
        self.cardBackgroundView.isHidden = true
        
        self.selectEmotionContainerView.backgroundColor = .clear
        self.selectEmotionContainerView.layer.cornerRadius = 10
        self.selectEmotionContainerView.layer.borderColor = Gen.Colors.black.color.cgColor
        self.selectEmotionContainerView.layer.borderWidth = 1
        
        self.currentEmotionLabel.font = .fonts(.subTitle)
        self.currentEmotionLabel.textColor = Gen.Colors.black.color
        self.currentEmotionLabel.text = "전시가 어땠나요?"
        
        self.contentsContainerView.backgroundColor = Gen.Colors.white.color
        
        self.helpLabel.font = .fonts(.subTitle)
        self.helpLabel.textColor = Gen.Colors.black.color
        self.helpLabel.text = "무슨 전시를 감상했나요?"
        
        self.archiveNameLabel.font = .fonts(.header2)
        self.archiveNameLabel.textColor = Gen.Colors.gray03.color
        self.archiveNameLabel.text = "전시명을 입력해주세요."
    }
    
    // MARK: internal function
    
    // MARK: action
    
    @IBAction func selectImageAction(_ sender: Any) {
        self.delegate?.selectImageClicked()
    }
    @IBAction func selectEmotionAction(_ sender: Any) {
        self.cardContainerView.isHidden = true
        self.delegate?.selectEmotionClicked()
    }
    @IBAction func selectContentsAction(_ sender: Any) {
        self.delegate?.selectContentsClicked()
    }
    

    

}
