//
//  TicketDescriptionContentView.swift
//  Archive
//
//  Created by TTOzzi on 2021/12/10.
//

import UIKit
import SnapKit

final class TicketDescriptionContentView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .fonts(.header3)
        label.textColor = Gen.Colors.black.color
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .fonts(.subTitle)
        label.textColor = Gen.Colors.black.color
        return label
    }()
    
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

        UIColor.white.set()
        
        path.fill()
    }
    
    func setLayout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(14)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(20)
        }
        
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.titleLabel.snp.leading)
            $0.trailing.equalTo(self.titleLabel.snp.trailing)
        }
    }
}
