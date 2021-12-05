//
//  ViewController.swift
//  Archive
//
//  Created by hanwe on 2021/12/05.
//

import UIKit

protocol ModalShareViewControllerDelegate: AnyObject {
    func instagramShareClicked()
    func photoShareClicked()
}

class ModalShareViewController: UIViewController {

    @IBOutlet weak var contentsContainerView: UIView!
    @IBOutlet weak var shareInstagramBtn: UIButton!
    @IBOutlet weak var shareImageBtn: UIButton!
    @IBOutlet weak var instagramTitleLabel: UILabel!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    
    weak var delegate: ModalShareViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        self.instagramTitleLabel.font = .fonts(.subTitle)
        self.instagramTitleLabel.textColor = Gen.Colors.black.color
        self.instagramTitleLabel.text = "Instagram"
        
        self.imageTitleLabel.font = .fonts(.subTitle)
        self.imageTitleLabel.textColor = Gen.Colors.black.color
        self.imageTitleLabel.text = "Image"
        
        self.closeLabel.font = .fonts(.button)
        self.closeLabel.textColor = Gen.Colors.black.color
        self.closeLabel.text = "취소"
        self.closeLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close(_:)))
        self.closeLabel.addGestureRecognizer(tap)
        
        self.contentsContainerView.isHidden = true
    }
    
    func fadeIn() {
        self.contentsContainerView.isHidden = false
        self.contentsContainerView.fadeIn(completeHandler: {
            
        })
    }

    @IBAction func shareInstaAction(_ sender: Any) {
        self.delegate?.instagramShareClicked()
    }
    
    @IBAction func sharePhotoAction(_ sender: Any) {
        self.delegate?.photoShareClicked()
    }
    
    @objc func close(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: false)
    }
}
