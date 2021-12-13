//
//  LoginModule.swift
//  Archive
//
//  Created by hanwe on 2021/12/12.
//

import UIKit
import Moya
import RxSwift
import Alamofire

class LoginModule: NSObject {
    static func loginEmail(eMail: String, password: String) -> Observable<Result<HTTPHeaders, Error>> {
        let provider = ArchiveProvider.shared.provider
        let param = LoginEmailParam(email: eMail, password: password)
        return provider.rx.request(.loginEmail(param), callbackQueue: DispatchQueue.global())
            .asObservable()
            .map { result in
                if let headers = result.response?.headers {
                    return .success(headers)
                } else {
                    return .failure(NSError())
                }
            }
            .catch { err in
                .just(.failure(err))
            }
    }
}
