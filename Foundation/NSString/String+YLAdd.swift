//
//  NSString+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/9/27.
//

import Foundation

extension String {
    //32位长度uuid
    static var UUID: String {
        let uuidRef = CFUUIDCreate(nil);
        let uuidStringRef = CFUUIDCreateString(nil,uuidRef);
        return uuidStringRef! as String;
    }
    
    var length: Int {
        return self.count;
    }
    
    func doubleValue() -> Double {
        if let doubleValue = Double(self) {
            return doubleValue
        }
        return 0.0
    }
    
    func floatValue() -> CGFloat {
        if let doubleValue = Double(self) {
            return CGFloat(doubleValue)
        }
        return 0.0
    }
    
    func intValue() -> Int {
        if let doubleValue = Double(self) {
            return Int(doubleValue)
        }
        return 0
    }
    
    func dataValue() -> Data? {
        return self.data(using: .utf8)
    }
    
    func jsonObject() -> Any {
        return self.dataValue()?.jsonObject() as Any
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    /// 截取字符
    /// - Parameter index: 位置
    /// - Returns: 字符
    func characterAtIndex(_ index: Int) -> Character? {
        var currentIndex = 0
        for char in self {
            if currentIndex == index {
                return char
            }
            currentIndex+=1;
        }
        return nil
    }
    
    /// 十进制转十六进制
    /// - Returns: 十六进制字符串
    func decimalToHex() -> String {
        return String(self.intValue(), radix: 16)
    }
    
    /// 十进制转十六进制
    /// - Parameter lenght: 总长度，不足补0
    /// - Returns: 十六进制字符串
    func decimalToHexWithLength(lenght: Int) -> String {
        var subString = String(self.intValue(), radix: 16)
        let moreL = length - subString.length;
        if (moreL>0) {
            for _ in 0 ..< moreL {
                subString += "0"
            }
        }
        return subString
    }
    
    /// 解析URL参数
    /// - Parameters:
    ///   - key: 想要获取参数的名字
    /// - Returns: 对应参数的值
    func urlParamForKey(_ key: String) -> String {
        let regTags = String(format: "(^|&|\\?)+%@=+([^&]*)(&|$)", key)
        let regex = try? NSRegularExpression(pattern: regTags, options: .caseInsensitive)
        guard let matches = regex?.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.length)) else { return "" }
        for match in matches {
            return self.substring(rang: match.range(at: 2))
        }
        return ""
    }
    
    func chineseNum() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.numberStyle = .spellOut
        return formatter.string(from: NSDecimalNumber(string: self)) ?? ""
    }
    
    /** orderedAscending：前者小于后者
     * orderedSame：两者相等
     * orderedDescending：
     * 前者大于后者
     */
    func versionCompare(_ otherVersion: String) -> ComparisonResult  {
        var v1 = self.split(separator: ".")
        var v2 = otherVersion.split(separator: ".")
        let diff = v1.count - v2.count
        
        if (diff == 0) {
            return v1.joined().compare(v2.joined())
        } else {
            if (diff > 0) {
                v2.append(contentsOf: (0..<diff).map { _ in "0" })
            } else {
                v1.append(contentsOf: (0..<abs(diff)).map { _ in "0" })
            }
            return v1.joined().compare(v2.joined())
        }
    }
}
