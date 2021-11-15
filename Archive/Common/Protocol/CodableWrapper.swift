//
//  CodableWrapper.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import Foundation

public protocol CodableWrapper: Codable, Equatable {
    
    associatedtype selfType: CodableWrapper
    
    static func fromJson(jsonData: Data?) -> selfType?
    
    func toJson() -> String
}

extension CodableWrapper {
    public static func fromJson(jsonData: Data?) -> selfType? {
        var returnValue: selfType?
        let decoder = JSONDecoder()
        if let data = jsonData, let result = try? decoder.decode(selfType.self, from: data) {
            returnValue = result
        }
        return returnValue
    }
}

extension CodableWrapper {
    public func toJson() -> String {
        var jsonString: String = ""
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.outputFormatting = .sortedKeys
        let jsonData = try? encoder.encode(self)
        if jsonData != nil {
            jsonString = String(data: jsonData!, encoding: .utf8) ?? ""
        }
        return jsonString
    }
}
