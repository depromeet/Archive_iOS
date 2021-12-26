//
//  DetailContentsCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/12/26.
//

import UIKit

class DetailContentsCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContainerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainContentsView: UIView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var contentsLabel: UILabel!
    
    // MARK: private property
    
    // MARK: internal property
    
    var infoData: ArchiveDetailImageInfo? {
        didSet {
            guard let info = self.infoData else { return }
            DispatchQueue.main.async { [weak self] in
                self?.mainContentsView.backgroundColor = info.backgroundColor.colorWithHexString()
                self?.mainImageView.kf.setImage(with: URL(string: info.image),
                                               placeholder: nil,
                                               options: [.cacheMemoryOnly],
                                               completionHandler: { [weak self] _ in
                    self?.mainImageView.fadeIn(duration: 0.1, completeHandler: nil)
                })
                self?.contentsLabel.text = info.review
            }
        }
    }
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.mainBackgroundView.backgroundColor = Gen.Colors.white.color
        self.scrollView.backgroundColor = .clear
        self.mainContentsView.backgroundColor = .clear
        
        self.bottomContainerView.backgroundColor = Gen.Colors.white.color
        
        self.contentsLabel.font = .fonts(.body)
        self.contentsLabel.textColor = Gen.Colors.black.color
        
    }
    
    // MARK: internal function
    
    // MARK: action
    

}
