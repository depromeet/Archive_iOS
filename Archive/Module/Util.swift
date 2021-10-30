//
//  Util.swift
//  Archive
//
//  Created by hanwe on 2021/10/29.
//

import UIKit

class Util {
    static func moveToSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}
