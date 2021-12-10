//
//  TicketDescriptionContentView.swift
//  Archive
//
//  Created by TTOzzi on 2021/12/10.
//

import UIKit

final class TicketDescriptionContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let size = bounds.size

        let p1 = CGPoint(x: 30, y: .zero)
        let p2 = CGPoint(x: size.width - 30, y: .zero)
        let p3 = CGPoint(x: size.width - 15, y: 10)
        let cp34 = CGPoint(x: size.width, y: 20)
        let p4 = CGPoint(x: size.width, y: 30)
        let p5 = CGPoint(x: size.width, y: size.height)
        let p6 = CGPoint(x: .zero, y: size.height)
        let p7 = CGPoint(x: .zero, y: 30)
        let cp78 = CGPoint(x: .zero, y: 20)
        let p8 = CGPoint(x: 15, y: 10)

        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addQuadCurve(to: p4, controlPoint: cp34)
        path.addLine(to: p5)
        path.addLine(to: p6)
        path.addLine(to: p7)
        path.addQuadCurve(to: p8, controlPoint: cp78)
        path.close()

        UIColor.orange.set()
        path.fill()
    }
}
