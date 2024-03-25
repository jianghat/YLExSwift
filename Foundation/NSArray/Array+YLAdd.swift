//
//  Array.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/21.
//

import Foundation

extension Array {
    func toJson() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
