//
//  UIDeviceExtension.swift
//  Archive
//
//  Created by hanwe on 2021/10/31.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = window?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
