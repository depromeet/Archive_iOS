//
//  HWPhotoListFromAlbumView.swift
//  GetPhotoListFromAlbum
//
//  Created by hanwe on 08/07/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

import UIKit
import Photos

enum HWPhotoListSelectType {
    case single
    case multi
}

protocol HWPhotoListFromAlbumViewDelegate: AnyObject {
    func selectedImgsFromAlbum(selectedImg: [PHAsset: PhotoFromAlbumModel], focusIndexAsset: PHAsset)
    func changeFocusImg(focusIndex: Int)
}

class HWPhotoListFromAlbumView: UIView {
    
    // MARK: outlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    // MARK: varReplace
    var imgWidth: CGFloat = 300
    var imgHeight: CGFloat = 300
    var minimumLineSpacing: CGFloat = 4.0
    var minimumInteritemSpacing: CGFloat = 4.0
    
    // MARK: var
    var fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: PHFetchOptions())
    
    weak var delegate: HWPhotoListFromAlbumViewDelegate?
    
    public var maxSelectCnt = 10
    
    var selectType: HWPhotoListSelectType = .single {
        didSet {
            switch self.selectType {
            case .single:
                self.selectedIndexDic.removeAll()
                let modelObj: PhotoFromAlbumModel = PhotoFromAlbumModel()
                modelObj.sequenceNum = 0
                modelObj.asset = self.fetchResult[self.focusImgIndex]
                self.selectedIndexDic[self.fetchResult[self.focusImgIndex]] = modelObj
            case .multi:
                break
            }
            DispatchQueue.main.async { [weak self] in
                self?.imgCollectionView.reloadData()
            }
        }
    }
    
    var selectedIndexDic: Dictionary = [PHAsset: PhotoFromAlbumModel]()
    var focusImgIndex: Int = -1
    
    // MARK: life cycle
    
    override func awakeFromNib() {
        initUI()
        initFuntion()
    }
    
    // MARK: func
    
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> HWPhotoListFromAlbumView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? HWPhotoListFromAlbumView
    }
    
    func initUI() {
        self.imgCollectionView.register(UINib(nibName: "PhotoFromAlbumCell", bundle: nil), forCellWithReuseIdentifier: "PhotoFromAlbumCell")
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = self.minimumLineSpacing
        layout.minimumInteritemSpacing = self.minimumInteritemSpacing
        self.imgCollectionView.collectionViewLayout = layout
    }
    
    func initFuntion() {
        setFetchAsset()
        PHPhotoLibrary.shared().register(self)
    }
    
    func setFetchAsset() {
        let allPhotosOptions: PHFetchOptions = PHFetchOptions()
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        requestOptions.isSynchronous = true
        self.fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: self.imgWidth, height: self.imgHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func getOriginAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func setFocusAtIndex(index: Int) {
        self.focusImgIndex = index
        self.delegate?.changeFocusImg(focusIndex: self.focusImgIndex)
        self.delegate?.selectedImgsFromAlbum(selectedImg: self.selectedIndexDic, focusIndexAsset: self.fetchResult[self.focusImgIndex])
    }
}

extension HWPhotoListFromAlbumView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var resultInt: Int = 0
        if collectionView == self.imgCollectionView {
            resultInt = self.fetchResult.count
        }
        return resultInt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFromAlbumCell", for: indexPath) as? PhotoFromAlbumCell else { return UICollectionViewCell() }
        cell.mainImgView.image = getAssetThumbnail(asset: self.fetchResult.object(at: indexPath.row))
        let item = self.selectedIndexDic[self.fetchResult[indexPath.row]]
        if self.selectType == .multi {
            cell.sequenceNumberContainerView.isHidden = false
        } else {
            cell.sequenceNumberContainerView.isHidden = true
        }
        
        cell.infoData = item
        
        if self.focusImgIndex == indexPath.item {
            cell.coverView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        } else {
            cell.coverView.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.imgCollectionView {
            if self.selectType == .multi { // 다중선택모드
                if self.selectedIndexDic[self.fetchResult[indexPath.row]] == nil { // 선택되지 않은 인덱스
                    if self.selectedIndexDic.count < self.maxSelectCnt { // 최대 선택 가능수보다 작을때만 동작
                        let modelObj: PhotoFromAlbumModel = PhotoFromAlbumModel()
                        modelObj.asset = self.fetchResult[indexPath.row]
                        modelObj.sequenceNum = self.selectedIndexDic.count
                        self.selectedIndexDic[self.fetchResult[indexPath.row]] = modelObj
                        setFocusAtIndex(index: indexPath.row)
                        if let cell: PhotoFromAlbumCell = collectionView.cellForItem(at: indexPath) as? PhotoFromAlbumCell {
                            cell.mainImgView.isHidden = false
                        }
                        self.delegate?.selectedImgsFromAlbum(selectedImg: self.selectedIndexDic, focusIndexAsset: self.fetchResult[self.focusImgIndex])
                    } else {
                        AudioServicesPlaySystemSound(1521)
                        if let cell: PhotoFromAlbumCell = collectionView.cellForItem(at: indexPath) as? PhotoFromAlbumCell {
                            cell.mainImgView.transform = CGAffineTransform(translationX: 10, y: 10)
                            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                                cell.mainImgView.transform = .identity
                            }) { (true) in
                                
                            }
                        }
                        return
                    }
                } else { // 이미 선택 된 인덱스
                    if self.focusImgIndex == indexPath.row { // 선택된 이미지를 선택되지않은 이미지로 상태변경(모델 삭제)
                        let keyArr = Array(self.selectedIndexDic.keys)
                        for i in 0..<keyArr.count {
                            let nowSequenceNum = self.selectedIndexDic[keyArr[i]]!.sequenceNum
                            if nowSequenceNum > self.selectedIndexDic[self.fetchResult[indexPath.row]]!.sequenceNum { // 지우는 인덱스의 선택순서보다 내가 더 늦게 선택된거라면
                                self.selectedIndexDic[keyArr[i]]!.sequenceNum -= 1 // 선택된순서를 하나 줄인다.
                            }
                        }
                        self.selectedIndexDic[self.fetchResult[indexPath.row]] = nil // 삭제
                        let keyArr2 = Array(self.selectedIndexDic.keys)
                        for i in 0..<keyArr2.count { // 삭제 후 포커스인덱스 변경작업
                            let nowSequenceNum = self.selectedIndexDic[keyArr2[i]]!.sequenceNum
                            let willgetFocusIndex = self.selectedIndexDic.count - 1
                            if nowSequenceNum == willgetFocusIndex {
                                setFocusAtIndex(index: self.fetchResult.index(of: keyArr2[i]))
                                break
                            }
                        }
                        self.delegate?.selectedImgsFromAlbum(selectedImg: self.selectedIndexDic, focusIndexAsset: self.fetchResult[self.focusImgIndex])
                    } else { // 포커스만 변경
                        setFocusAtIndex(index: indexPath.row)
                    }
                }
            } else { // 단일선택모드
                let keyArr = Array(self.selectedIndexDic.keys)
                if self.fetchResult[indexPath.row] != keyArr[0] {
                    self.selectedIndexDic.removeAll()
                    let modelObj: PhotoFromAlbumModel = PhotoFromAlbumModel()
                    modelObj.sequenceNum = 0
                    modelObj.asset = self.fetchResult[indexPath.row]
                    self.selectedIndexDic[self.fetchResult[indexPath.row]] = modelObj
                    setFocusAtIndex(index: indexPath.row)
                }
            }
        }
        self.imgCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var resultCGSize = CGSize(width: 0, height: 0)
        if collectionView == self.imgCollectionView {
            let myWidth: CGFloat = self.frame.width
            resultCGSize = CGSize(width: (myWidth - 3*self.minimumLineSpacing)/4, height: (myWidth - 3*self.minimumLineSpacing)/4)
        }
        return resultCGSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var resultEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if collectionView == self.imgCollectionView {
            resultEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return resultEdgeInsets
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension HWPhotoListFromAlbumView: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        let allPhotosOptions: PHFetchOptions = PHFetchOptions()
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        requestOptions.isSynchronous = true
        guard let changes = changeInstance.changeDetails(for: self.fetchResult) else { return }
        
        if changes.removedIndexes != nil {
            let removeArr = Array(changes.removedObjects)
            var willFocusMoveNum = 0
            for i in 0..<removeArr.count {
                if self.fetchResult[self.focusImgIndex] == removeArr[i] {
                    self.focusImgIndex = 0
                    break
                } else if self.focusImgIndex > self.fetchResult.index(of: removeArr[i]) {
                    willFocusMoveNum -= 1
                }
            }
            self.focusImgIndex += willFocusMoveNum
            if self.focusImgIndex < 0 {
                self.focusImgIndex = 0
            }
            let removeArr2 = Array(changes.removedObjects)
            var removedSequenceIndex: Array = [Int]()
            for i in 0..<removeArr2.count { // 선택된 객체 삭제
                if self.selectedIndexDic[removeArr2[i]] != nil {
                    removedSequenceIndex.append(self.selectedIndexDic[removeArr2[i]]!.sequenceNum)
                    self.selectedIndexDic[removeArr2[i]] = nil
                }
            }
            let keyArr = Array(self.selectedIndexDic.keys)
            for i in 0..<keyArr.count { // sequenceNum수정
                var willReduceNum = 0
                willReduceNum = 0
                for j in 0..<removedSequenceIndex.count {
                    if self.selectedIndexDic[keyArr[i]]!.sequenceNum >= removedSequenceIndex[j] {
                        willReduceNum += 1
                    }
                }
                self.selectedIndexDic[keyArr[i]]!.sequenceNum -= willReduceNum
            }
        }
        
        if changes.insertedIndexes != nil {
            let insertArr = Array(changes.insertedObjects)
            var willFocusMoveNum = 0
            for i in 0..<insertArr.count {
                if self.fetchResult[self.focusImgIndex].creationDate!.timeIntervalSince1970 <= insertArr[i].creationDate!.timeIntervalSince1970 {
                    willFocusMoveNum += 1
                }
            }
            self.focusImgIndex += willFocusMoveNum
        }
        
        DispatchQueue.main.async {
            self.setFetchAsset()
            self.setFocusAtIndex(index: self.focusImgIndex)
            if self.selectType == .single { // 싱글셀렉트모드의경우
                if self.selectedIndexDic.count == 0 {
                    let modelObj: PhotoFromAlbumModel = PhotoFromAlbumModel()
                    modelObj.sequenceNum = 0
                    modelObj.asset = self.fetchResult[0]
                    self.selectedIndexDic[self.fetchResult[0]] = modelObj
                }
            }
            self.imgCollectionView.reloadData()
        }
    }
}
