//
//  ConditionCheckmarkView.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

@IBDesignable
final class ConditionCheckmarkView: UIView {
    
    @IBInspectable var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = .zero
        return stackView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fonts(.body)
        label.textColor = Gen.Colors.gray02.color
        return label
    }()
    private lazy var checkMarkImageView = UIImageView()
    fileprivate var isValid: Bool = false {
        didSet {
            updateView(isValid)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAttributes()
        setupLayouts()
    }
    
    private func setupAttributes() {
        updateView(isValid)
    }
    
    private func setupLayouts() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(checkMarkImageView)
        checkMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(26)
        }
    }
    
    private func updateView(_ isValid: Bool) {
        if isValid {
            checkMarkImageView.image = Gen.Images.checkSquareSelected.image
            titleLabel.textColor = Gen.Colors.gray02.color
        } else {
            checkMarkImageView.image = Gen.Images.checkSquareDeselected.image
            titleLabel.textColor = Gen.Colors.gray03.color
        }
    }
}

extension Reactive where Base: ConditionCheckmarkView {
    var isValid: Binder<Bool> {
        return Binder(base) { conditionCheckMarkView, isValid in
            conditionCheckMarkView.isValid = isValid
        }
    }
}
