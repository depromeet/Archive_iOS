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
    @IBOutlet weak var coverLabelContainerView: UIView!
    @IBOutlet weak var coverLabel: UILabel!
    
    // MARK: var
    
    var infoData: PhotoFromAlbumModel? {
        didSet {
            guard let info = self.infoData else {
                self.coverView.layer.borderWidth = 0
                self.sequenceNumberContainerView.isHidden = true
                self.coverLabelContainerView.isHidden = true
                return
            }
            self.coverView.layer.borderWidth = 1
            self.sequenceNumberContainerView.isHidden = false
            self.sequenceNumberLabel.text = "\(info.sequenceNum + 1)"
            if info.sequenceNum == 0 {
                self.coverLabelContainerView.isHidden = false
            } else {
                self.coverLabelContainerView.isHidden = true
            }
        }
    }
    
    // MARK: life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        
    }
    
    // MARK: func
    
    private func initUI() {
        self.coverView.backgroundColor = .clear
        self.coverView.layer.borderColor = Gen.Colors.black.color.cgColor
        self.sequenceNumberContainerView.backgroundColor = Gen.Colors.black.color
        self.sequenceNumberLabel.textColor = Gen.Colors.white.color
        self.sequenceNumberLabel.font = .fonts(.button)
        self.sequenceNumberContainerView.sizeToFit()
        self.coverLabelContainerView.backgroundColor = Gen.Colors.black.color
        self.coverLabel.textColor = Gen.Colors.white.color
        self.coverLabel.font = .fonts(.button)
        self.coverLabel.text = "표지"
    }
    
    // MARK: action


}
