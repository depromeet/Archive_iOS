//
//  TicketImageContentView.swift
//  Archive
//
//  Created by TTOzzi on 2021/12/10.
//

import UIKit

final class TicketImageContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let size = bounds.size
        
        let p1 = CGPoint(x: size.width, y: .zero)
        let p2 = CGPoint(x: size.width, y: size.height - 30)
        let cp23 = CGPoint(x: size.width, y: size.height - 20)
        let p3 = CGPoint(x: size.width - 15, y: size.height - 10)
        let p4 = CGPoint(x: size.width - 30, y: size.height)
        let p5 = CGPoint(x: 30, y: size.height)
        let p6 = CGPoint(x: 15, y: size.height - 10)
        let cp67 = CGPoint(x: .zero, y: size.height - 20)
        let p7 = CGPoint(x: .zero, y: size.height - 30)

        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: p1)
        path.addLine(to: p2)
        path.addQuadCurve(to: p3, controlPoint: cp23)
        path.addLine(to: p4)
        path.addLine(to: p5)
        path.addLine(to: p6)
        path.addQuadCurve(to: p7, controlPoint: cp67)
        path.close()

        UIColor.red.set()
        path.fill()
    }
}
