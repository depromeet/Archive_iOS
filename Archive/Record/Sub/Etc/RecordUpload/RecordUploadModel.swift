//
//  RecordUploadModel.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit

protocol RecordUploadModelProtocol: AnyObject {
    var contents: ContentsRecordModelData { get set }
    var thumbnailImage: UIImage { get set }
    var emotion: Emotion { get set }
    var imageInfos: [ImageInfo]? { get set }
    
    func record(completion: @escaping () -> Void)
}

class RecordUploadModel: RecordUploadModelProtocol {
    // MARK: private property
    
    // MARK: internal property
    
    var contents: ContentsRecordModelData
    var thumbnailImage: UIImage
    var emotion: Emotion
    var imageInfos: [ImageInfo]?
    
    // MARK: lifeCycle
    
    init(contents: ContentsRecordModelData, thumbnailImage: UIImage, emotion: Emotion, imageInfos: [ImageInfo]?) {
        self.contents = contents
        self.thumbnailImage = thumbnailImage
        self.emotion = emotion
        self.imageInfos = imageInfos
    }
    
    // MARK: private function
    
    private func uploadImages(completion: @escaping ([RecordImageData]) -> Void) {
        var recordImageDatas: [RecordImageData] = [RecordImageData]()
        if let infos = self.imageInfos {
            for item in infos {
                // TODO: 이미지 업로드 및 데이터 처리
            }
        } else {
            completion(recordImageDatas)
        }
    }
    
    // MARK: internal function
    
    func record(completion: @escaping () -> Void) {
        uploadImages(completion: { [weak self] recordImageDatas in
            
        })
    }
    
}


struct RecordData: CodableWrapper {
    typealias selfType = RecordData
    
    let name: String
    let watchedOn: String
    let companions: [String]?
    let emotion: String
    let mainImage: String
    let images: [RecordImageData]?
    
}

struct RecordImageData: CodableWrapper {
    typealias selfType = RecordImageData
    
    let image: String
    let review: String?
}
