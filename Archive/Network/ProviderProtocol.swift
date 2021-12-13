//
//  ProviderProtocol.swift
//  Archive
//
//  Created by hanwe on 2021/11/22.
//

import Moya
import Alamofire

public protocol ProviderPtotocol: AnyObject {
    associatedtype T: TargetType
    
    var provider: MoyaProvider<T> { get set }
    init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((T) -> Endpoint)?)
}

public extension ProviderPtotocol {
    static func consProvider(_ isStub: Bool = false, _ sampleStatusCode: Int = 200, _ customEndpointClosure: ((T) -> Endpoint)? = nil) -> MoyaProvider<T> {
        if !isStub {
            return MoyaProvider<T>()
        } else {
            // 테스트 시에 호출되는 stub 클로져
            let endPointClosure = { (target: T) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }
                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
            return MoyaProvider<T>(
                endpointClosure: customEndpointClosure ?? endPointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }
}
