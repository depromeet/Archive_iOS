//
//  PhotoFromAlbumCell.swift
//  GetPhotoListFromAlbum
//
//  Created by hanwe on 05/07/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

import UIKit

class PhotoFromAlbumCell: UICollectionViewCell {

    // MARK: outlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var sequenceNumberContainerView: UIView!
    @IBOutlet weak var sequenceNumberLabel: UILabel!
    
    // MARK: var
    
    // MARK: life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        
    }
    
    // MARK: func
    
    private func initUI() {
        self.coverView.backgroundColor = .clear
        self.sequenceNumberContainerView.layer.cornerRadius = self.sequenceNumberContainerView.frame.width/2
        self.sequenceNumberContainerView.layer.borderWidth = 1
        self.sequenceNumberContainerView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.38).cgColor
        self.sequenceNumberLabel.textColor = .white
        self.sequenceNumberLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 13)
        self.sequenceNumberContainerView.sizeToFit()
    }
    
    // MARK: action


}
