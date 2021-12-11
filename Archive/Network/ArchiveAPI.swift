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
    case registEmail(_ param: RequestEmailParam)
    case loginEmail(_ param: LoginEmailParam)
    case isDuplicatedEmail(_ eMail: String)
    case deleteArchive(archiveId: String)
    case getArchives
    case getDetailArchive(archiveId: String)
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
        case .registEmail:
            return "/api/v1/auth/register"
        case .loginEmail:
            return "/api/v1/auth/login"
        case .isDuplicatedEmail(let eMail):
            return "/api/v1/auth/email/" + eMail
        case .deleteArchive(let archiveId):
            return "/api/v1/archive/" + archiveId
        case .getArchives:
            return "/api/v1/archive"
        case .getDetailArchive(let archiveId):
            return "/api/v1/archive/" + archiveId
        }
    }
    
    var method: Method {
        switch self {
        case .uploadImage:
            return .post
        case .registArchive:
            return .post
        case .registEmail:
            return .post
        case .loginEmail:
            return .post
        case .isDuplicatedEmail:
            return .get
        case .deleteArchive:
            return .delete
        case .getArchives:
            return .get
        case .getDetailArchive:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .uploadImage:
            return Data()
        case .registArchive:
            return Data()
        case .registEmail:
            return Data()
        case .loginEmail:
            return Data()
        case .isDuplicatedEmail:
            return Data()
        case .deleteArchive:
            return Data()
        case .getArchives:
            return Data()
        case .getDetailArchive:
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
        case .registEmail(let param):
            return .requestJSONEncodable(param)
        case .loginEmail(let param):
            return .requestJSONEncodable(param)
        case .isDuplicatedEmail:
            return .requestPlain
        case .deleteArchive:
            return .requestPlain
        case .getArchives:
            return .requestPlain
        case .getDetailArchive:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        switch self {
        case .isDuplicatedEmail:
            return nil
        case .loginEmail:
            return nil
        case .registArchive:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .registEmail:
            return nil
        case .uploadImage:
            return nil
        case .deleteArchive:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .getArchives:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .getDetailArchive:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        }
    }
    
}


