//
//  FlipView.swift
//  FlipAnimation
//
//  Created by hanwe on 2021/10/02.
//

import UIKit

public protocol HWFlipViewDelegate: AnyObject {
    func flipViewWillFliped(flipView: HWFlipView, foregroundView: UIView, behindeView: UIView, willShow: HWFlipView.FlipType)
    func flipViewDidFliped(flipView: HWFlipView, foregroundView: UIView, behindeView: UIView, didShow: HWFlipView.FlipType)
}

public class HWFlipView: UIView {
    
    public enum FlipType {
        case foreground
        case behind
    }
    
    // MARK: private property
    private var foregroundView: UIView?
    private var behindView: UIView?
    private(set) var currentFlipType: FlipType = .foreground
    private let containerView: UIView = UIView()
    
    // MARK: internal property
    public weak var delegate: HWFlipViewDelegate?
    
    // MARK: lifeCycle
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        DispatchQueue.main.async {
            self.addSubview(self.containerView)
            self.containerView.translatesAutoresizingMaskIntoConstraints = false
            let constraint1 = NSLayoutConstraint(item: self.containerView, attribute: .leading, relatedBy: .equal,
                                                 toItem: self, attribute: .leading,
                                                 multiplier: 1.0, constant: 0)
            let constraint2 = NSLayoutConstraint(item: self.containerView, attribute: .trailing, relatedBy: .equal,
                                                 toItem: self, attribute: .trailing,
                                                 multiplier: 1.0, constant: 0)
            let constraint3 = NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal,
                                                 toItem: self, attribute: .top,
                                                 multiplier: 1.0, constant: 0)
            let constraint4 = NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal,
                                                 toItem: self, attribute: .bottom,
                                                 multiplier: 1.0, constant: 0)
            self.addConstraints([constraint1, constraint2, constraint3, constraint4])
        }
    }
    
    private func flip(type: FlipType, complition: (() -> Void)?) {
        guard let foregroundView = self.foregroundView else { return }
        guard let behindView = self.behindView else { return }
        let willtransType: FlipType = type == .behind ? .foreground : .behind
        
        self.delegate?.flipViewWillFliped(flipView: self, foregroundView: foregroundView, behindeView: behindView, willShow: willtransType)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.containerView, duration: 0.35, options: .transitionFlipFromLeft, animations: nil, completion: { [weak self] isEndAnimation in
                if isEndAnimation {
                    guard let self = self else { return }
                    self.foregroundView?.isHidden = true
                    self.behindView?.isHidden = false
                    self.delegate?.flipViewDidFliped(flipView: self, foregroundView: self.foregroundView ?? UIView(), behindeView: self.behindView ?? UIView(), didShow: willtransType)
                    self.currentFlipType = willtransType
                    complition?()
                }
            })
        }
    }
    
    // MARK: internal function
    
    public func flip(complition: (() -> Void)?) {
        flip(type: self.currentFlipType, complition: complition)
    }
    
    public func setForegroundView(_ foregroundView: UIView) {
        if let view = self.behindView {
            view.clearConstraintsForFlipView()
        }
        self.foregroundView = foregroundView
        DispatchQueue.main.async {
            self.containerView.addSubview(foregroundView)
            foregroundView.translatesAutoresizingMaskIntoConstraints = false
            
            let constraint1 = NSLayoutConstraint(item: foregroundView, attribute: .leading, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .leading,
                                                 multiplier: 1.0, constant: 0)
            
            let constraint2 = NSLayoutConstraint(item: foregroundView, attribute: .trailing, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .trailing,
                                                 multiplier: 1.0, constant: 0)
            
            let constraint3 = NSLayoutConstraint(item: foregroundView, attribute: .top, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .top,
                                                 multiplier: 1.0, constant: 0)
            
            let constraint4 = NSLayoutConstraint(item: foregroundView, attribute: .bottom, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .bottom,
                                                 multiplier: 1.0, constant: 0)
                    
            self.addConstraints([constraint1, constraint2, constraint3, constraint4])
            // 이 함수를 두번 호출하면 constraints들이 남아있어서 버그가 일어날수도....
        }
    }
    
    public func setBehindViewView(_ behindView: UIView) {
        if let view = self.behindView {
            view.clearConstraintsForFlipView()
        }
        self.behindView = behindView
        DispatchQueue.main.async {
            self.containerView.addSubview(behindView)
            behindView.translatesAutoresizingMaskIntoConstraints = false
            
            let constraint1 = NSLayoutConstraint(item: behindView, attribute: .leading, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .leading,
                                                 multiplier: 1.0, constant: 0)
            
            let constraint2 = NSLayoutConstraint(item: behindView, attribute: .trailing, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .trailing,
                                                 multiplier: 1.0, constant: 0)
            
            let constraint3 = NSLayoutConstraint(item: behindView, attribute: .top, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .top,
                                                 multiplier: 1.0, constant: 0)
            
            let constraint4 = NSLayoutConstraint(item: behindView, attribute: .bottom, relatedBy: .equal,
                                                 toItem: self.containerView, attribute: .bottom,
                                                 multiplier: 1.0, constant: 0)
                    
            self.addConstraints([constraint1, constraint2, constraint3, constraint4])
            self.behindView?.isHidden = true
        }
    }
    
}

extension UIView {
    func clearConstraintsForFlipView() {
        for subview in self.subviews {
            subview.clearConstraintsForFlipView()
        }
        self.removeConstraints(self.constraints)
    }
}
