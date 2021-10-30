//
//  NibIdentifiable.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit

protocol NibIdentifiable: AnyObject {
    static var nib: UINib { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
