//
//  ReuseIdentifiable.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import UIKit

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UIViewController: ReuseIdentifiable { }
