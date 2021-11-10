//
//  InstagramStoryShareManager.swift
//  Archive
//
//  Created by hanwe on 2021/11/10.
//

import UIKit

class InstagramStoryShareManager: NSObject {
    
    // MARK: private property
    
    private let instagramStoryScheme: String = "instagram-stories://share"
    private let stickerImageKey: String = "com.instagram.sharedSticker.stickerImage"
    private let backgroundTopColorKey: String = "com.instagram.sharedSticker.backgroundTopColor"
    private let backgroundBottomColorKey: String = "com.instagram.sharedSticker.backgroundBottomColor"
    
    // MARK: property
    
    // MARK: lifeCycle
    
    // MARK: private func
    
    private func colorToHexStr(_ color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format: "#%06x", rgb) as String
    }
    
    // MARK: func
    
    static let shared: InstagramStoryShareManager = {
        let instance = InstagramStoryShareManager()
        return instance
    }()
    
    func share(view: UIView, backgroundTopColor: UIColor, backgroundBottomColor: UIColor, completion: @escaping (Bool) -> Void, failure: @escaping (String) -> Void) {
        if let storyShareURL = URL(string: self.instagramStoryScheme) {
            if UIApplication.shared.canOpenURL(storyShareURL) {
                let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
                let renderImage = renderer.image { _ in
                    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                }
                guard let imageData = renderImage.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    self.stickerImageKey: imageData,
                    self.backgroundTopColorKey: colorToHexStr(backgroundTopColor),
                    self.backgroundBottomColorKey: colorToHexStr(backgroundBottomColor)
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: { value in
                    completion(value)
                })
            } else {
                failure("인스타그램이 필요합니다")
            }
        }
    }
}
