//
//  ContentsRecordCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

protocol ContentsRecordCollectionViewCellDelegate: AnyObject {
    
}

class ContentsRecordCollectionViewCell: UICollectionViewCell, StoryboardView, ClassIdentifiable {
    
    // MARK: IBOutlet
    
    // MARK: private property
    
    // MARK: internal property
    
    weak var delegate: ContentsRecordCollectionViewCellDelegate?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func bind(reactor: ContentsRecordReactor) {
        
    }
    
    // MARK: private function
    
    private func initUI() {
        
    }
    
    // MARK: internal function
    
    // MARK: action
    
    

    
    
    
}
