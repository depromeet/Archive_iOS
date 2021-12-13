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

struct ArchiveDetailInfo: CodableWrapper {
    typealias selfType = ArchiveDetailInfo
    
    let archiveId: Int
    let authorId: Int
    let name: String
    let watchedOn: String
    let emotion: String
    let companions: [String]?
    let mainImage: String
    let images: [ArchiveDetailImageInfo]?
}

struct ArchiveDetailImageInfo: CodableWrapper {
    typealias selfType = ArchiveDetailImageInfo
    
    let review: String
    let image: String
    let backgroundColor: String
    let archiveImageId: Int
}
