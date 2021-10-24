//
//  ClassIdentifiable.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit

protocol ClassIdentifiable: AnyObject {
    static var identifier: String { get }
}

extension ClassIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
    
    var identifier: String {
        return String(describing: type(of: self))
    }
}
