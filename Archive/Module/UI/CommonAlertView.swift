//
//  CommonAlertView.swift
//
//  Created by hanwe lee on 2021/10/23.
//  Copyright © 2021 hanwe lee. All rights reserved.
//

import UIKit
import SnapKit

class CommonAlertView: UIView {
    
    // MARK: property
    
    var comfirmHandler: (() -> Void)?
    var cancelHandler: (() -> Void)?
    
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    // MARK: function
    static let shared: CommonAlertView = {
        let instance = CommonAlertView()
        instance.frame = UIScreen.main.bounds
        let scene = UIApplication.shared.connectedScenes.first
        if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
            instance.isHidden = true
            instance.alpha = 0
            sd.window?.addSubview(instance)
        }
        return instance
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)
        setGenerator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct ScreenSize {
        static let Width         = UIScreen.main.bounds.size.width
        static let Height        = UIScreen.main.bounds.size.height
        static let Max_Length    = max(ScreenSize.Width, ScreenSize.Height)
        static let Min_Length    = min(ScreenSize.Width, ScreenSize.Height)
    }
    
    private func setGenerator() {
        self.feedbackGenerator = UINotificationFeedbackGenerator()
        self.feedbackGenerator?.prepare()
    }
    
    func showAlertType1(message: String, subMessage: String? = nil, btnText: String, hapticType: UINotificationFeedbackGenerator.FeedbackType? = nil, confirmHandler: @escaping () -> Void) { // 확인버튼 하나만 있는것
        DispatchQueue.main.async {
            self.superview?.bringSubviewToFront(self)
            self.comfirmHandler = confirmHandler
            let buttonView: UIView = UIView()
            buttonView.backgroundColor = .clear
            
            let confirmBtnView: UIView = UIView()
            confirmBtnView.layer.cornerRadius = 8
            confirmBtnView.backgroundColor = .black
            let confirmBtnLabel: UILabel = UILabel()
            confirmBtnLabel.font = .fonts(.button)
            confirmBtnLabel.textColor = .white
            confirmBtnLabel.textAlignment = .center
            confirmBtnLabel.text = btnText
            confirmBtnView.addSubview(confirmBtnLabel)
            confirmBtnLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(confirmBtnView.snp.leading).offset(0)
                make.trailing.equalTo(confirmBtnView.snp.trailing).offset(0)
                make.centerY.equalTo(confirmBtnView.snp.centerY).offset(0)
            }
            let confirmTaps = UITapGestureRecognizer(target: self, action: #selector(self.confirmAction(_:)))
            confirmBtnView.addGestureRecognizer(confirmTaps)
            
            buttonView.addSubview(confirmBtnView)
            confirmBtnView.snp.makeConstraints { (make) in
                make.top.equalTo(buttonView.snp.top).offset(0)
                make.bottom.equalTo(buttonView.snp.bottom).offset(0)
                make.leading.equalTo(buttonView.snp.leading).offset(0)
                make.trailing.equalTo(buttonView.snp.trailing).offset(0)
            }
            
            let alertView: UIView = self.makeMainAlertView(message: message, subMessage: subMessage, buttonView: buttonView)
            
            self.addSubview(alertView)
            alertView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX).offset(0)
                make.centerY.equalTo(self.snp.centerY).offset(0)
                make.width.equalTo(311)
            }
            
            self.isHidden = false
            if hapticType != nil {
                self.feedbackGenerator?.notificationOccurred(hapticType!)
            }
            
            self.fadeIn(completeHandler: nil)
        }
    }
    
    func showAlertType2(message: String, subMessage: String?, confirmBtnTxt: String, cancelBtnTxt: String, confirmHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) { // 버튼 두개짜리
        DispatchQueue.main.async {
            self.superview?.bringSubviewToFront(self)
            self.comfirmHandler = confirmHandler
            self.cancelHandler = cancelHandler
            let buttonView: UIView = UIView()
            buttonView.backgroundColor = .clear

            let cancelBtnView: UIView = UIView()
            cancelBtnView.backgroundColor = .white
            cancelBtnView.layer.borderColor = UIColor.black.cgColor
            cancelBtnView.layer.borderWidth = 1
            cancelBtnView.layer.cornerRadius = 8
            let cancelBtnLabel: UILabel = UILabel()
            cancelBtnLabel.font = .fonts(.button)
            cancelBtnLabel.textColor = .black
            cancelBtnLabel.textAlignment = .center
            cancelBtnLabel.text = cancelBtnTxt
            cancelBtnView.addSubview(cancelBtnLabel)
            cancelBtnLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(cancelBtnView.snp.leading).offset(0)
                make.trailing.equalTo(cancelBtnView.snp.trailing).offset(0)
                make.centerY.equalTo(cancelBtnView.snp.centerY).offset(0)
            }
            let cancelTaps = UITapGestureRecognizer(target: self, action: #selector(self.cancelAction(_:)))
            cancelBtnView.addGestureRecognizer(cancelTaps)

            let confirmBtnView: UIView = UIView()
            confirmBtnView.backgroundColor = .black
            confirmBtnView.layer.cornerRadius = 8
            let confirmBtnLabel: UILabel = UILabel()
            confirmBtnLabel.font = .fonts(.button)
            confirmBtnLabel.textColor = .white
            confirmBtnLabel.backgroundColor = .clear
            confirmBtnLabel.textAlignment = .center
            confirmBtnLabel.text = confirmBtnTxt
            confirmBtnView.addSubview(confirmBtnLabel)
            confirmBtnLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(confirmBtnView.snp.leading).offset(0)
                make.trailing.equalTo(confirmBtnView.snp.trailing).offset(0)
                make.centerY.equalTo(confirmBtnView.snp.centerY).offset(0)
            }
            let confirmTaps = UITapGestureRecognizer(target: self, action: #selector(self.confirmAction(_:)))
            confirmBtnView.addGestureRecognizer(confirmTaps)

            buttonView.addSubview(cancelBtnView)
            buttonView.addSubview(confirmBtnView)
            cancelBtnView.snp.makeConstraints { (make) in
                make.leading.equalTo(buttonView.snp.leading).offset(0)
                make.top.equalTo(buttonView.snp.top).offset(0)
                make.bottom.equalTo(buttonView.snp.bottom).offset(0)
                make.width.equalTo(120)
            }
            confirmBtnView.snp.makeConstraints { (make) in
                make.trailing.equalTo(buttonView.snp.trailing).offset(0)
                make.top.equalTo(buttonView.snp.top).offset(0)
                make.bottom.equalTo(buttonView.snp.bottom).offset(0)
                make.width.equalTo(120)
            }

            let alertView: UIView = self.makeMainAlertView(message: message, subMessage: subMessage, buttonView: buttonView)

            self.addSubview(alertView)
            alertView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX).offset(0)
                make.centerY.equalTo(self.snp.centerY).offset(0)
                make.width.equalTo(311)
            }

            self.isHidden = false
            self.fadeIn(completeHandler: nil)
        }
    }
    
    private func makeMainAlertView(message: String, subMessage: String?, buttonView: UIView) -> UIView {
        
        let alertView: UIView = UIView()
        alertView.backgroundColor = .white
        let messageLabel: UILabel = UILabel()
        messageLabel.font = .fonts(.header3)
        messageLabel.text = message
        messageLabel.textAlignment = .left
        messageLabel.textColor = Gen.Colors.gray02.color
        messageLabel.numberOfLines = 10
        let subMessageLabel: UILabel = UILabel()
        if subMessage != nil {
            subMessageLabel.text = subMessage!
        }
        subMessageLabel.textAlignment = .left
        subMessageLabel.textColor = Gen.Colors.gray02.color
        subMessageLabel.numberOfLines = 10
        let buttonContainerView: UIView = UIView()
        buttonContainerView.backgroundColor = .clear
        alertView.addSubview(messageLabel)
        alertView.addSubview(subMessageLabel)
        alertView.addSubview(buttonContainerView)
        alertView.layer.cornerRadius = 20
        alertView.clipsToBounds = true
        
        messageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(alertView.snp.leading).offset(32)
            make.trailing.equalTo(alertView.snp.trailing).offset(-32)
            make.top.equalTo(alertView.snp.top).offset(16)
        }
        
        if subMessage == nil {
            subMessageLabel.font = UIFont(name: "", size: 0)
        } else {
            subMessageLabel.font = .fonts(.body)
        }
        
        subMessageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(alertView.snp.leading).offset(32)
            make.trailing.equalTo(alertView.snp.trailing).offset(-32)
            make.top.equalTo(messageLabel.snp.bottom).offset(8)
        }
        
        buttonContainerView.snp.makeConstraints { (make) in
            make.leading.equalTo(alertView.snp.leading).offset(0)
            make.trailing.equalTo(alertView.snp.trailing).offset(0)
            make.top.equalTo(subMessageLabel.snp.bottom).offset(40)
            make.bottom.equalTo(alertView.snp.bottom).offset(0)
            make.height.equalTo(72)
        }
        
        buttonContainerView.addSubview(buttonView)
        buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(buttonContainerView.snp.top).offset(0)
            make.bottom.equalTo(buttonContainerView.snp.bottom).offset(-20) // -20?
            make.leading.equalTo(buttonContainerView.snp.leading).offset(32)
            make.trailing.equalTo(buttonContainerView.snp.trailing).offset(-32)
        }
        
        return alertView
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.fadeOut {
                self.removeAllSubview()
                self.isHidden = true
                completion?()
            }
        }
    }
    
    @objc func cancelAction(_ recognizer: UITapGestureRecognizer) {
        self.cancelHandler?()
    }
    @objc func confirmAction(_ recognizer: UITapGestureRecognizer) {
        self.comfirmHandler?()
    }
    
    
}
