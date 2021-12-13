//
//  EmotionDefine.swift
//  Archive
//
//  Created by hanwe lee on 2021/10/25.
//

enum Emotion: String, CaseIterable {
    case fun = "INTERESTING"
    case impressive = "IMPRESSIVE"
    case pleasant = "PLEASANT"
    case splendid = "BEAUTIFUL"
    case wonderful = "AMAZING"
    
    static func fromString(_ str: String) -> Emotion? {
        for item in Emotion.allCases {
            if item.rawValue == str {
                return item
            }
        }
        return nil
    }
}
