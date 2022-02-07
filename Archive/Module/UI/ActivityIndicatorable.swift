//
//  ActivityIndicatorable.swift
//  Archive
//
//  Created by hanwe on 2021/10/30.
//

import UIKit
import Lottie

protocol ActivityIndicatorable where Self: UIViewController {
    func startIndicatorAnimating()
    func stopIndicatorAnimating()
}

private var activityIndicatorableAssociatedObjectKey: Void?

extension ActivityIndicatorable {
    
    private var indicatorView: AnimationView {
        get {
            var indicator = objc_getAssociatedObject(self, &activityIndicatorableAssociatedObjectKey) as? AnimationView
            if indicator == nil {
                indicator = AnimationView()
                indicator?.backgroundColor = .clear
                indicator?.animation = Animation.named("SignUp")
                indicator?.contentMode = .scaleAspectFit
                indicator?.loopMode = .loop
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
        indicatorView.centerInSuperview(size: CGSize(width: 30, height: 30))
        view.bringSubviewToFront(indicatorView)
        indicatorView.play()
    }
    
    func stopIndicatorAnimating() {
        indicatorView.stop()
        indicatorView.removeFromSuperview()
    }
}

