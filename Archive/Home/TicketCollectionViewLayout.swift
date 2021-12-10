//
//  TicketCollectionViewLayout.swift
//  Archive
//
//  Created by TTOzzi on 2021/11/11.
//

import UIKit

final class TicketCollectionViewLayout: UICollectionViewLayout {
    
    private let visibleItemsCount: Int
    private let minimumScale: CGFloat
    private let horizontalInset: CGFloat
    private let spacing: CGFloat
    var itemSize: CGSize = .zero {
        didSet { invalidateLayout() }
    }
    var itemCount: CGFloat {
        return CGFloat(collectionView?.numberOfItems(inSection: .zero) ?? .zero)
    }
    var bounds: CGRect {
        return collectionView?.bounds ?? .zero
    }
    var contentOffset: CGPoint {
        return collectionView?.contentOffset ?? .zero
    }
    var currentPage: Int {
        return max(Int(contentOffset.x) / Int(bounds.width), .zero)
    }
    private var didInitialSetup = false
    override var collectionViewContentSize: CGSize {
        return CGSize(width: bounds.width * itemCount, height: bounds.height)
    }
    
    init(visibleItemsCount: Int, minimumScale: CGFloat, horizontalInset: CGFloat, spacing: CGFloat) {
        self.visibleItemsCount = visibleItemsCount
        self.minimumScale = minimumScale
        self.horizontalInset = horizontalInset
        self.spacing = spacing
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        guard didInitialSetup == false else { return }
        didInitialSetup = true
        
        let width = bounds.width * 0.8
        let height = width / 0.6
        itemSize = CGSize(width: width, height: height)
        
        collectionView?.setContentOffset(.zero, animated: false)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard itemCount.isZero == false else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let minVisibleIndex = currentPage
        let offset = CGFloat(Int(contentOffset.x) % Int(bounds.width))
        let offsetProgress = CGFloat(offset) / bounds.width
        let maxVisibleIndex = min(Int(itemCount) - 1, currentPage + visibleItemsCount - 1)
        let attributes: [UICollectionViewLayoutAttributes] = (minVisibleIndex...maxVisibleIndex).map {
            let indexPath = IndexPath(item: $0, section: .zero)
            return layoutAttributes(for: indexPath, offset, offsetProgress)
        }
        
        return attributes
    }
    
    private func layoutAttributes(for indexPath: IndexPath,
                                  _ offset: CGFloat,
                                  _ offsetProgress: CGFloat) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        
        let topCellCenterX = contentOffset.x + bounds.width - itemSize.width / 2 - horizontalInset / 2 - spacing
        attributes.zIndex = Int(itemCount) - indexPath.item
        attributes.center = CGPoint(x: topCellCenterX + spacing * CGFloat(indexPath.item - currentPage), y: bounds.midY)
        
        let scale = cellScale(for: indexPath.item, offsetProgress)
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let isVisibleIndex = indexPath.item > currentPage
        let movedX = isVisibleIndex ? spacing * offsetProgress : offset
        attributes.center.x -= movedX
        
        return attributes
    }
    
    private func cellScale(for index: Int, _ offsetProgress: CGFloat) -> CGFloat {
        let step = (1.0 - minimumScale) / CGFloat(visibleItemsCount)
        return 1.0 - CGFloat(index - currentPage) * step + step * offsetProgress
    }
}
