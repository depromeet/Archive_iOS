//
//  DetailFriendsCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/12/26.
//

import UIKit

class DetailFriendsCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    // MARK: private property
    
    // MARK: internal property
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.layer.cornerRadius = 4
        self.mainContainerView.backgroundColor = Gen.Colors.gray01.color
        self.mainTitleLabel.font = .fonts(.subTitle)
        self.mainTitleLabel.textColor = Gen.Colors.gray06.color
    }
    
    // MARK: internal function
    
    // MARK: action
    

    

}
