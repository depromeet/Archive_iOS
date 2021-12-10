//
//  ArchiveInfo.swift
//  Archive
//
//  Created by TTOzzi on 2021/12/10.
//

struct ArchiveInfo: Decodable {
    let archiveId: Int
    let name: String
    let watchedAt: String
    let emotion: String
    let companions: [String]?
    let mainImage: String
}
