//
//  UIFontExtension.swift
//  Archive
//
//  Created by hanwe on 2021/10/10.
//

import UIKit

enum ArchiveFonts {
    case header1
    case header2
    case header3
    case subTitle
    case body
    case button
    case caption
}


extension UIFont {
    static func fonts(_ font: ArchiveFonts) -> UIFont {
        var optionalReturnFont: UIFont?
        switch font {
        case .header1:
            optionalReturnFont = UIFont(name: FontDefine.bold, size: 34)
        case .header2:
            optionalReturnFont = UIFont(name: FontDefine.bold, size: 24)
        case .header3:
            optionalReturnFont = UIFont(name: FontDefine.bold, size: 20)
        case .subTitle:
            optionalReturnFont = UIFont(name: FontDefine.medium, size: 16)
        case .body:
            optionalReturnFont = UIFont(name: FontDefine.regular, size: 14)
        case .button:
            optionalReturnFont = UIFont(name: FontDefine.medium, size: 14)
        case .caption:
            optionalReturnFont = UIFont(name: FontDefine.regular, size: 18)
        }
        guard let returnFont = optionalReturnFont else { return UIFont() }
        return returnFont
    }
}
