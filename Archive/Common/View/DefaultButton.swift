//
//  DefaultButton.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/16.
//

import UIKit

class DefaultButton: UIButton {
    
    private enum Styles {
        static let defaultColor = UIColor.black
        static let highlightedColor = Gen.Colors.gray03.color
        static let disabledColor = Gen.Colors.gray04.color
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Styles.highlightedColor : Styles.defaultColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAttributes()
    }
    
    private func setupAttributes() {
        setBackgroundColor(Styles.defaultColor, for: .normal)
        setBackgroundColor(Styles.disabledColor, for: .disabled)
    }
}
