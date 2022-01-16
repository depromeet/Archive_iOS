//
//  CardRecordCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2022/01/08.
//

import UIKit

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
    @IBOutlet weak var archiveNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
    
    
    
    
    // MARK: private property
    
    // MARK: internal property
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        
    }
    
    // MARK: internal function
    
    // MARK: action
    

    

}
