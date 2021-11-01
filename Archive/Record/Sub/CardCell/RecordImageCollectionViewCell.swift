//
//  RecordImageCollectionViewCell.swift
//  Archive
//
//  Created by hanwe lee on 2021/11/01.
//

import UIKit

class RecordImageCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: outlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: private property
    
    // MARK: property
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private func
    
    private func initUI() {
        self.mainContainerView.backgroundColor = .clear // 이미지 분석..?
        self.mainImageView.contentMode = .scaleToFill
    }
    
    // MARK: func
    
    // MARK: action

}
