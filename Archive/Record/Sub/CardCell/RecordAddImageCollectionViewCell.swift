//
//  RecordAddImageCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/11/02.
//

import UIKit

class RecordAddImageCollectionViewCell: UICollectionViewCell, ClassIdentifiable {

    @IBOutlet weak var mainContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        self.mainContainerView.backgroundColor = Gen.Colors.gray05.color
    }

}
