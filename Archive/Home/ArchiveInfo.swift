//
//  ArchiveInfo.swift
//  Archive
//
//  Created by TTOzzi on 2021/12/10.
//

struct ArchiveInfo: CodableWrapper {
    typealias selfType = ArchiveInfo
    
    let archiveId: Int
    let authorId: Int
    let name: String
    let watchedOn: String
    let emotion: String
    let companions: [String]?
    let mainImage: String
}
