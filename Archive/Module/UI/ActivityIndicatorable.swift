//
//  ActivityIndicatorable.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit

protocol ActivityIndicatorable where Self: UIViewController {
    func startIndicatorAnimating()
    func stopIndicatorAnimating()
}

private var activityIndicatorableAssociatedObjectKey: Void?

extension ActivityIndicatorable {
    private var indicatorView: UIActivityIndicatorView {
        get {
            var indicator = objc_getAssociatedObject(self, &activityIndicatorableAssociatedObjectKey) as? UIActivityIndicatorView
            if indicator == nil {
                indicator = UIActivityIndicatorView()
                if #available(iOS 13.0, *) {
                    indicator?.style = .large
                } else {
                    indicator?.style = .whiteLarge
                }
                objc_setAssociatedObject(self, &activityIndicatorableAssociatedObjectKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return indicator!
        }
        set {
            objc_setAssociatedObject(self, &activityIndicatorableAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func startIndicatorAnimating() {
        view.addSubview(indicatorView)
        indicatorView.centerInSuperview()
        view.bringSubviewToFront(indicatorView)
        indicatorView.startAnimating()
    }
    
    func stopIndicatorAnimating() {
        indicatorView.removeFromSuperview()
    }
}

