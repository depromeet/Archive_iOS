//
//  TopConerRadiusView.swift
//  Archive
//
//  Created by hanwe on 2021/11/10.
//

import UIKit

class TopConerRadiusView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
}
