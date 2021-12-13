//
//  RecordUploadModel.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import UIKit
import Moya
import RxSwift
import Alamofire
import SwiftyJSON

protocol RecordUploadModelProtocol: AnyObject {
    var contents: ContentsRecordModelData { get set }
    var thumbnailImage: UIImage { get set }
    var emotion: Emotion { get set }
    var imageInfos: [ImageInfo]? { get set }
    
    func record(completion: @escaping () -> Void)
}

class RecordUploadModel: RecordUploadModelProtocol {
    // MARK: private property
    
    private var disposeBag: DisposeBag = DisposeBag()
    
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
        if let infos = self.imageInfos, infos.count != 0 {
            var observarbleRequests = [Observable<Response>]()
            var photoContents: [String] = [String]()
            var colors: [String] = [String]()
            let provider = ArchiveProvider.shared.provider
            for item in infos {
                let request = provider.rx.request(.uploadImage(item.image)).asObservable()
                observarbleRequests.append(request)
                photoContents.append(item.contents ?? "")
                colors.append(item.backgroundColor.hexStringFromColor())
            }
            Observable.zip(observarbleRequests)
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { results in
                    for i in 0..<results.count {
                        if let result: JSON = try? JSON.init(data: results[i].data) {
                            let data = RecordImageData(image: result["imageUrl"].stringValue, review: photoContents[i], backgroundColor: colors[i])
                            recordImageDatas.append(data)
                        }
                    }
                    completion(recordImageDatas)
                })
                .disposed(by: self.disposeBag)
        } else {
            completion(recordImageDatas)
        }
    }
    
    private func uploadMainImage(completion: @escaping (String) -> Void) {
        let provider = ArchiveProvider.shared.provider
        provider.request(.uploadImage(self.thumbnailImage), completion: { response in
            switch response {
            case .success(let result):
                if let result: JSON = try? JSON.init(data: result.data) {
                    completion(result["imageUrl"].stringValue)
                } else {
                    completion("")
                }
            case .failure(_):
                completion("")
            }
        })
    }
    
    // MARK: internal function
    
    func record(completion: @escaping () -> Void) {
        uploadImages(completion: { [weak self] recordImageDatas in
            self?.uploadMainImage(completion: { mainImageUrl in
                let recordData = RecordData(name: self?.contents.title ?? "",
                                            watchedOn: self?.contents.date ?? "",
                                            companions: self?.contents.friends ?? nil,
                                            emotion: self?.emotion.rawValue ?? "",
                                            mainImage: mainImageUrl,
                                            images: recordImageDatas)
                let provider = ArchiveProvider.shared.provider
                provider.request(.registArchive(recordData), completion: { response in
                    switch response {
                    case .success(_):
                        completion()
                    case .failure(let err):
                        print("err:\(err)")
                        completion()
                    }
                })
            })
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
    let review: String
    let backgroundColor: String
}
