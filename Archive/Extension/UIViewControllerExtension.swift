//
//  UIViewControllerExtension.swift
//  Archive
//
//  Created by hanwe on 2021/12/26.
//

import UIKit

extension UIViewController {

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
}
