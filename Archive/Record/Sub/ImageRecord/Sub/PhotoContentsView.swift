//
//  PhotoContentsView.swift
//  Archive
//
//  Created by hanwe on 2021/11/09.
//

import UIKit

protocol PhotoContentsViewDelegate: AnyObject {
    func photoCellContentsConfirmed(text: String?, index: Int)
}

class PhotoContentsView: UIView, NibIdentifiable {
    
    // MARK: IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    // MARK: property
    
    weak var delegate: PhotoContentsViewDelegate?
    
    var imageInfo: ImageInfo? {
        didSet {
            guard let info = self.imageInfo else { return }
            if let contents = info.contents {
                DispatchQueue.main.async { [weak self] in
                    self?.textView.textColor = Gen.Colors.black.color
                    self?.textView.text = contents
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.textView.textColor = Gen.Colors.gray02.color
                    self?.textView.text = "이 작품의 감상은 어땠어요?"
                }
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
        self.textView.text = ""
        self.textView.font = .fonts(.body)
        self.textView.delegate = self
        let eventNameTextViewDoneButton = UIBarButtonItem.init(title: "완료", style: .done, target: self, action: #selector(self.titleTextViewDone))
        let eventNameTextViewToolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 44))
        eventNameTextViewToolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), eventNameTextViewDoneButton], animated: true)
        self.textView.inputAccessoryView = eventNameTextViewToolBar
    }
    
    // MARK: internal function
    
    class func instance() -> PhotoContentsView? {
        return nib.instantiate(withOwner: nil, options: nil).first as? PhotoContentsView
    }
    
    // MARK: private function
    
    // MARK: action
    
    @objc private func titleTextViewDone() {
        let text = self.textView.text == "" ? nil : self.textView.text
        self.delegate?.photoCellContentsConfirmed(text: text, index: self.index)
        self.textView.resignFirstResponder()
    }
    
}

extension PhotoContentsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Gen.Colors.gray02.color {
            textView.text = nil
            textView.textColor = Gen.Colors.black.color
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "이 작품의 감상은 어땠어요?"
            textView.textColor = Gen.Colors.gray02.color
        }
    }
}
