//
//  PhotoContentsView.swift
//  Archive
//
//  Created by hanwe on 2021/11/09.
//

import UIKit

class DetailPhotoContentsView: UIView, NibIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var contentsTextView: UITextView!
    
    // MARK: property
    
    var imageInfo: RecordImageData? {
        didSet {
            guard let info = self.imageInfo else { return }
            DispatchQueue.main.async { [weak self] in
                self?.contentsTextView.text = info.review
            }
        }
    }
    
    var index: Int = -1
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.contentsTextView.text = ""
        self.contentsTextView.textColor = Gen.Colors.black.color
        self.contentsTextView.font = .fonts(.body)
        self.contentsTextView.isEditable = false
    }
    
    // MARK: internal function
    
    class func instance() -> DetailPhotoContentsView? {
        return nib.instantiate(withOwner: nil, options: nil).first as? DetailPhotoContentsView
    }
    
    // MARK: private function
    
    // MARK: action
    
}
