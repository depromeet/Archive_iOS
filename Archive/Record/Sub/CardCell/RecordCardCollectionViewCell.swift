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
    
    // MARK: func
    
    // MARK: action

}
