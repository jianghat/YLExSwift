//
//  String+YLEncry.swift
//  Driver
//
//  Created by ym on 2020/10/5.
//

import Foundation
import CommonCrypto
import CryptoKit

extension String {
    /**
     *   md5 加密
     *   return 加密字符串
     */
    func md5() -> String! {
        let data = self.data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /**
     *   Base64 加密
     *   return 加密字符串
     */
    func encodeToBase64() -> String {
        guard let data = self.data(using: .utf8) else {
            print("加密失败")
            return ""
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    /**
     *   Base64 解密
     *   return 解密字符串
     */
    func decodeBase64() -> String {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            print("解密失败");
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }
    
    func sha256() -> Data {
        let data: Data = self.data(using: .utf8)!;
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
}
