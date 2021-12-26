//
//  DetailContentsCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/12/26.
//

import UIKit
import SnapKit

class DetailContentsCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContainerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainContentsView: UIView!
    
    @IBOutlet weak var centerContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageCoverView: UIView!
    
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
    
    var emotion: Emotion = .fun
    var name: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let rotatedView = self?.makeRotatedTitleView(emotion: self?.emotion ?? .fun, title: self?.name ?? "") {
                    self?.mainImageCoverView.addSubview(rotatedView)
                    guard let self = self else { return }
                    let offset: CGFloat = self.getRotatedViewOffset()
                    rotatedView.snp.makeConstraints {
                        $0.leading.equalTo(self.mainImageCoverView.snp.leading).offset(offset + 28)
                        $0.height.equalTo(56)
                        $0.centerY.equalTo(self.mainImageCoverView.snp.centerY).offset(0)
                    }
                }
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
    
    private func makeRotatedTitleView(emotion: Emotion, title: String) -> UIView {
        let view: UIView = UIView()
        view.backgroundColor = Gen.Colors.white.color
        
        let emotionView: UIImageView = UIImageView()
        switch emotion {
        case .fun:
            emotionView.image = Gen.Images.typeFun.image
        case .impressive:
            emotionView.image = Gen.Images.typeImpressive.image
        case .pleasant:
            emotionView.image = Gen.Images.typePleasant.image
        case .splendid:
            emotionView.image = Gen.Images.typeSplendid.image
        case .wonderful:
            emotionView.image = Gen.Images.typeWonderful.image
        }
        view.addSubview(emotionView)
        emotionView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(40)
            $0.centerY.equalTo(view.snp.centerY).offset(0)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        let titleLabel: UILabel = UILabel()
        titleLabel.font = .fonts(.subTitle)
        titleLabel.textColor = Gen.Colors.black.color
        titleLabel.text = title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(emotionView.snp.trailing).offset(10)
            $0.centerY.equalTo(view.snp.centerY).offset(0)
            $0.trailing.equalTo(view.snp.trailing).offset(-40)
        }
        
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        return view
    }
    
    private func getRotatedViewOffset() -> CGFloat {
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.fonts(.subTitle)]
        return -(((self.name as NSString).size(withAttributes: fontAttributes).width + 110)/2)
    }
    
    // MARK: internal function
    
    // MARK: action
    

}
