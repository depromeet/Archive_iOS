//
//  ArchiveProvider.swift
//  Archive
//
//  Created by hanwe on 2021/11/22.
//

import Moya

class ArchiveProvider: ProviderPtotocol {
    typealias T = ArchiveAPI
    var provider: MoyaProvider<ArchiveAPI>
    
    required init(isStub: Bool, sampleStatusCode: Int = 200, customEndpointClosure: ((ArchiveAPI) -> Endpoint)? = nil) {
        provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
}
