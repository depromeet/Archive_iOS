//
//  HomeShimmerView.swift
//  Archive
//
//  Created by hanwe on 2021/12/10.
//

import UIKit

class HomeShimmerView: UIView, NibIdentifiable {
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        
    }
    
    // MARK: internal function
    
    class func instance() -> HomeShimmerView? {
        return nib.instantiate(withOwner: nil, options: nil).first as? HomeShimmerView
    }
    
    func startShimmering() {
        
    }
    
    func stopShimmering() {
        
    }
    
    // MARK: action
    
}
