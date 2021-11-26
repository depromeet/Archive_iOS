//
//  ArchiveAPI.swift
//  Archive
//
//  Created by hanwe on 2021/11/22.
//

import Moya

enum ArchiveAPI {
    case uploadImage(_ image: UIImage)
    case registArchive(_ info: RecordData)
}

extension ArchiveAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://3.38.66.239:8080")!
    }
    
    var path: String {
        switch self {
        case .uploadImage:
            return "/api/v1/archive/image/upload"
        case .registArchive:
            return "/api/v1/archive"
        }
    }
    
    var method: Method {
        switch self {
        case .uploadImage:
            return .post
        case .registArchive:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .uploadImage:
            return Data()
        case .registArchive:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .uploadImage(let image):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            let data: MultipartFormData = MultipartFormData(provider: .data(image.pngData()!), name: "image", fileName: "\(dateFormatter.string(from: Date())).jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([data])
        case .registArchive(let infoData):
            return .requestJSONEncodable(infoData)
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        return nil
    }
    
}


