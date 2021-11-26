//
//  StringExtension.swift
//  Archive
//
//  Created by hanwe on 2021/11/13.
//

import CommonCrypto

extension String {
    func passwordEnc() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return data.base64EncodedString()
    }
}
