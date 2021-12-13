//
//  UIViewExtension.swift
//  Archive
//
//  Created by hanwe on 2021/10/23.
//

import UIKit

extension UIView {
    func fadeOut(duration: TimeInterval = 0.2, completeHandler: (() -> Void)?) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: { (finished: Bool) -> Void in
            if finished {
                completeHandler?()
            }
        })
    }
    
    func fadeIn(duration: TimeInterval = 0.2, completeHandler: (() -> Void)?) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            if finished {
                completeHandler?()
            }
        })
    }
    
    func removeAllSubview() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
}
