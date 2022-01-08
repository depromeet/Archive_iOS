//
//  AppConfigManager.swift
//  Archive
//
//  Created by hanwe on 2022/01/08.
//

import UIKit

class AppConfigManager: NSObject {
    
    // MARK: private property
    
    // MARK: internal property
    
    var isPlayedIntroSplashView: Bool = false
    
    // MARK: lifeCycle
    
    // MARK: private function
    
    // MARK: internal function
    
    static let shared: AppConfigManager = {
        let instance = AppConfigManager()
        return instance
    }()
    
}
