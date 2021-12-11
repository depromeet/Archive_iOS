//
//  TicketCollectionViewCell.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/30.
//

import UIKit
import SnapKit
import Kingfisher

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
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var descriptionView: TicketDescriptionContentView = {
        let view = TicketDescriptionContentView()
        return view
    }()
    
    private lazy var emotionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var emotionTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .fonts(.subTitle)
        label.textColor = Gen.Colors.white.color
        return label
    }()
    
    var infoData: ArchiveInfo? {
        didSet {
            guard let info = self.infoData else { return }
            DispatchQueue.main.async { [weak self] in
                if let emotion: Emotion = Emotion.fromString(info.emotion) {
                    switch emotion {
                    case .fun:
                        self?.imageContentView.bgColor = Gen.Colors.funYellow.color
                        self?.coverImageView.image = Gen.Images.colorFun.image
                        self?.emotionImageView.image = Gen.Images.preFun.image
                        self?.emotionTitleLabel.text = "재미있는"
                    case .impressive:
                        self?.imageContentView.bgColor = Gen.Colors.impressiveGreen.color
                        self?.coverImageView.image = Gen.Images.colorImpressive.image
                        self?.emotionImageView.image = Gen.Images.preImpressive.image
                        self?.emotionTitleLabel.text = "인상적인"
                    case .pleasant:
                        self?.imageContentView.bgColor = Gen.Colors.pleasantRed.color
                        self?.coverImageView.image = Gen.Images.colorPleasant.image
                        self?.emotionImageView.image = Gen.Images.prePleasant.image
                        self?.emotionTitleLabel.text = "기분좋은"
                    case .splendid:
                        self?.imageContentView.bgColor = Gen.Colors.splendidBlue.color
                        self?.coverImageView.image = Gen.Images.colorSplendid.image
                        self?.emotionImageView.image = Gen.Images.preSplendid.image
                        self?.emotionTitleLabel.text = "아름다운"
                    case .wonderful:
                        self?.imageContentView.bgColor = Gen.Colors.wonderfulPurple.color
                        self?.coverImageView.image = Gen.Images.colorWonderful.image
                        self?.emotionImageView.image = Gen.Images.preWonderful.image
                        self?.emotionTitleLabel.text = "경이로운"
                    }
                    self?.imageContentView.setNeedsDisplay()
                }
                self?.mainImageView.kf.setImage(with: URL(string: info.mainImage),
                                                      placeholder: nil,
                                                      options: [.cacheMemoryOnly],
                                                      completionHandler: nil)
                self?.descriptionView.titleLabel.text = info.name
                self?.descriptionView.dateLabel.text = info.watchedOn
            }
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
        imageContentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints {
            $0.width.equalTo(mainImageView.snp.height)
            $0.leading.trailing.centerY.equalToSuperview()
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
        descriptionView.setLayout()
        
        imageContentView.addSubview(emotionImageView)
        emotionImageView.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.top.equalTo(imageContentView.snp.top).offset(20)
            $0.leading.equalTo(imageContentView.snp.leading).offset(20)
        }
        
        imageContentView.addSubview(emotionTitleLabel)
        emotionTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(emotionImageView.snp.centerY)
            $0.leading.equalTo(emotionImageView.snp.trailing).offset(8)
        }
    }
}
