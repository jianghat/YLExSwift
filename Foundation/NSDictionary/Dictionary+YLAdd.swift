//
//  NSDictionary+YLValueFormat.swift
//  Driver
//
//  Created by ym on 2020/10/10.
//

import Foundation

extension Dictionary {
    func intForKey(_ key: Dictionary.Key) -> Int {
        let value = self[key]
        if value == nil {
            return 0
        }
        if let s = value as? String {
            if let n = Int(s) {
                return n
            } else {
                print("Warning! Dictionary:\(self) int for key:'\(key)' value:'\(s)' is not cover to Int!")
                return 0
            }
        }
        if let i = value as? Int {
            return i
        }
        if let d = value as? Double {
            return Int(d)
        }
        return 0
    }
    
    func doubleForKey(_ key: Dictionary.Key) -> Double {
        let value = self[key]
        if value == nil {
            return 0.0
        }
        if let s = value as? String {
            if let n = Double(s) {
                return n
            } else {
                print("Warning! Dictionary:\(self) int for key:'\(key)' value:'\(s)' is not cover to Double!")
                return 0
            }
        }
        if let i = value as? Int {
            return Double(i)
        }
        if let d = value as? Double {
            return d
        }
        return 0.0
    }
    
    func boolForKey(_ key: Dictionary.Key) -> Bool {
        let value = self[key]
        if value == nil {
             return false
        }
        if let target = value as? Bool {
            return target
        }
        return false
    }
    
    func stringForKey(_ key: Dictionary.Key) -> String {
        let value = self[key]
        if value == nil {
            return ""
        }
        if let s = value as? String {
            return s
        }
        if let i = value as? Int {
            return i.description
        }
        if let d = value as? Double {
            return d.description
        }
        return ""
    }
    
    func arrayForKey(_ key: Dictionary.Key) -> [Any] {
        let value = self[key]
        if value == nil {
            return []
        }
        if let s = value as? [Any] {
            return s
        }
        if let s = value as? String {
            if let array = s.jsonObject() as? [Any] {
                return array
            }
        }
        return []
    }
    
    func objectForKey(_ key: Dictionary.Key) -> Any? {
        let value = self[key]
        if let s = value as? String {
            return s.jsonObject()
        }
        return value
    }
    
    func toJsonString() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return ""
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return ""
        }
        return str
    }
    
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
