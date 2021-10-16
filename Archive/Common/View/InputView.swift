//
//  InputView.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/16.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
final class InputView: UIView {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let horizontalPadding: CGFloat = 20
    }
    
    private enum Styles {
        static let placeholderColor = Gen.Colors.gray03.color
        static let borderColor = Gen.Colors.gray04.color
        static let focusedBorderColor = UIColor.black
    }
    
    @IBInspectable var placeholder: String? {
        get { textField.placeholder }
        set {
            guard let newValue = newValue else {
                textField.attributedPlaceholder = nil
                return
            }
            let attributes = [NSAttributedString.Key.foregroundColor: Styles.placeholderColor]
            textField.attributedPlaceholder = NSAttributedString(string: newValue, attributes: attributes)
        }
    }
    @IBInspectable var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    fileprivate lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .fonts(.body)
        return textField
    }()
    private var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAttributes()
        setupLayouts()
    }
    
    private func setupAttributes() {
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Styles.borderColor.cgColor
        
        textField.rx.controlEvent(.editingDidBegin)
            .map { Styles.focusedBorderColor.cgColor }
            .bind(to: layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .map { Styles.borderColor.cgColor }
            .bind(to: layer.rx.borderColor)
            .disposed(by: disposeBag)
    }
    
    private func setupLayouts() {
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }
    
    func focusTextField() {
        textField.becomeFirstResponder()
    }
}

extension Reactive where Base: InputView {
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    var editingDidEndOnExit: ControlEvent<Void> {
        return base.textField.rx.controlEvent(.editingDidEndOnExit)
    }
}
