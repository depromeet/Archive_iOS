//
//  ServerErrorUtil.swift
//  Archive
//
//  Created by hanwe on 2022/01/22.
//

import Moya
import SwiftyJSON

class ServerErrorUtil: NSObject {
    static func getErrMsg(_ err: Error) -> String {
        var returnValue: String = ""
        if let response = (err as? MoyaError)?.response {
            if let responseJson: JSON = try? JSON.init(data: response.data) {
                returnValue += responseJson["message"].stringValue + "\n"
                returnValue += "code: " + responseJson["code"].stringValue
            } else {
                returnValue += err.localizedDescription
            }
        } else {
            returnValue += err.localizedDescription
        }
        return returnValue
    }
}
