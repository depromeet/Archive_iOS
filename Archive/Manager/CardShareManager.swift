//
//  CardShareManager.swift
//  Archive
//
//  Created by hanwe on 2021/11/27.
//

import UIKit

class CardShareManager: NSObject {
    // MARK: private property
    
    // MARK: property
    
    // MARK: lifeCycle
    
    // MARK: private func
    
    // MARK: func
    
    static let shared: CardShareManager = {
        let instance = CardShareManager()
        return instance
    }()
    
    func share(view: UIView) -> UIActivityViewController? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let renderImage = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        guard let imageData = renderImage.pngData() else { return nil }
        let imageToShare = [imageData]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        return activityViewController
//        activityViewController.popoverPresentationController?.sourceView = self.shareBtn
//        activityViewController.isModalInPresentation = true
//
//        activityViewController.excludedActivityTypes = [.airDrop, .message]

//        self.present(activityViewController, animated: true, completion: nil)
    }
}
