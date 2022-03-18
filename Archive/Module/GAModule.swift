//
//  GAModule.swift
//  Archive
//
//  Created by hanwe on 2022/03/17.
//

import Foundation
import FirebaseAnalytics
import Firebase

class GAModule: NSObject {
    
    enum GAEvent {
        
        // 아카이브 등록
        case startRegistArchive
        case startEmotionSelect
        case completeEmotionSelect(selected: String)
        case startPhotoSelect
        case completePhotoSelect
        case completeRegistArchive
        
        // 공유
        case shareInstagramFromRegist
        case shareInstagramFromDetail
        case saveToPhotoAlbum
        
        // 내가 등록한 아카이브 보기
        case showDetail
        
    }
    
    static func sendEventLogToGA(_ event: GAEvent) {
        switch event {
        case .startRegistArchive:
            Analytics.logEvent("startRegistArchive", parameters: nil)
        case .startEmotionSelect:
            Analytics.logEvent("startEmotionSelect", parameters: nil)
        case .completeEmotionSelect(selected: let selected):
            Analytics.logEvent("completeEmotionSelect", parameters: ["emotion": selected])
        case .startPhotoSelect:
            Analytics.logEvent("startPhotoSelect", parameters: nil)
        case .completePhotoSelect:
            Analytics.logEvent("completePhotoSelect", parameters: nil)
        case .completeRegistArchive:
            Analytics.logEvent("completeRegistArchive", parameters: nil)
        case .shareInstagramFromRegist:
            Analytics.logEvent("shareInstagramFromRegist", parameters: nil)
        case .shareInstagramFromDetail:
            Analytics.logEvent("shareInstagramFromDetail", parameters: nil)
        case .saveToPhotoAlbum:
            Analytics.logEvent("saveToPhotoAlbum", parameters: nil)
        case .showDetail:
            Analytics.logEvent("showDetail", parameters: nil)
        }
    }
}
