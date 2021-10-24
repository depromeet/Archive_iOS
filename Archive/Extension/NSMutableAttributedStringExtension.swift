//
//  NSMutableAttributedStringExtension.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import UIKit

extension NSMutableAttributedString {
    
    func addAttributedStringInSpecificString(targetString: String, attr: [NSAttributedString.Key: Any]) {
        let range = (self.string as NSString).range(of: targetString)
        self.addAttributes(attr, range: range)
    }
}
