//
//  UIImageViewExtension.swift
//  Archive
//
//  Created by hanwe on 2021/11/01.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
