//
//  TicketCollectionViewCell.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/30.
//

import UIKit
import SnapKit

final class TicketCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var imageContentView: TicketImageContentView = {
        let view = TicketImageContentView()
        
        return view
    }()
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    private lazy var descriptionView: TicketDescriptionContentView = {
        let view = TicketDescriptionContentView()
        return view
    }()
    
    var infoData: ArchiveInfo? {
        didSet {
            print("infoData: \(infoData)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAttributes()
        setupLayouts()
    }
    
    private func setupAttributes() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
    }
    
    private func setupLayouts() {
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentStackView.addArrangedSubview(imageContentView)
        imageContentView.snp.makeConstraints {
            $0.width.equalTo(imageContentView.snp.height).multipliedBy(0.75)
        }
        imageContentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints {
            $0.width.equalTo(coverImageView.snp.height)
            $0.leading.trailing.centerY.equalToSuperview()
        }
        contentStackView.addArrangedSubview(descriptionView)
        descriptionView.snp.makeConstraints {
            $0.height.equalTo(imageContentView.snp.height).multipliedBy(0.3)
        }
    }
}
