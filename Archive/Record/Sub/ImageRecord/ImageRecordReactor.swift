//
//  ImageRecordReactor.swift
//  Archive
//
//  Created by hanwe on 2021/10/24.
//

import UIKit
import RxSwift
import ReactorKit
import UIImageColors

class ImageRecordReactor: Reactor {
    // MARK: private property
    
    private let model: ImageRecordModelProtocol
    
    // MARK: internal property
    
    let initialState = State()
    var isLoading: PublishSubject<Bool>
    
    // MARK: lifeCycle
    
    init(model: ImageRecordModelProtocol) {
        self.model = model
        self.isLoading = .init()
    }
    
    enum Action {
        case setThumbnailImage(_ image: UIImage)
        case setImages(_ images: [UIImage])
        case setEmotion(_ emotion: Emotion)
        case setImageInfos(_ infos: [ImageInfo])
    }
    
    enum Mutation {
        case setThumbnailImage(_ image: UIImage)
        case setImageInfos(_ images: [ImageInfo])
        case setEmotion(_ emotion: Emotion)
    }
    
    struct State {
        var thumbnailImage: UIImage?
        var imageInfos: [ImageInfo]?
        var emotion: Emotion?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setThumbnailImage(let image):
            return .just(.setThumbnailImage(image))
        case .setImages(let images):
            self.isLoading.onNext(true)
            makeImageInfos(images, completion: { [weak self] infos in
                self?.action.onNext(.setImageInfos(infos))
                self?.isLoading.onNext(false)
            })
            return .empty()
        case .setEmotion(let emotion):
            return .just(.setEmotion(emotion))
        case .setImageInfos(let infos):
            return .just(.setImageInfos(infos))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setThumbnailImage(let image):
            newState.thumbnailImage = image
        case .setImageInfos(let infos):
            newState.imageInfos = infos
        case .setEmotion(let emotion):
            newState.emotion = emotion
        }
        return newState
    }
    
    // MARK: private function
    
    private func makeImageInfos(_ images: [UIImage], completion: @escaping ([ImageInfo]) -> Void) {
        var returnValue: [ImageInfo] = [ImageInfo]()
        resize(images: images, scale: 0.2, completion: { [weak self] resizedImages in
            for i in 0..<images.count {
                let item: ImageInfo = ImageInfo(image: images[i], backgroundColor: resizedImages[i].getColors()?.background ?? .clear, contents: nil)
                returnValue.append(item)
            }
            completion(returnValue)
        })
    }
    
    private func resize(images: [UIImage], scale: CGFloat, completion: @escaping (([UIImage]) -> Void)) {
        DispatchQueue.global().async { [weak self] in
            var responseImages: [UIImage] = [UIImage]()
            for uiImage in images {
                guard let image: CGImage = uiImage.cgImage else { continue }
                let size = CGSize(width: CGFloat(image.width), height: CGFloat(image.height))
                let context = CGContext(
                    data: nil,
                    width: Int(size.width * scale),
                    height: Int(size.height * scale),
                    bitsPerComponent: 8,
                    bytesPerRow: 0,
                    space: CGColorSpaceCreateDeviceRGB(),
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
                context.interpolationQuality = .low
                context.draw(image, in: CGRect(origin: .zero, size: size))
                guard let resultImage = context.makeImage() else { continue }
                let resultUIImage: UIImage = UIImage(cgImage: resultImage)
                responseImages.append(resultUIImage)
            }
            completion(responseImages)
        }
    }
    
    // MARK: internal function
}
