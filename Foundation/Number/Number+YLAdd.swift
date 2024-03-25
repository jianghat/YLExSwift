//
//  Number+YLAdd.swift
//  gamefi-ios
//
//  Created by ym on 2024/2/20.
//

import UIKit

extension Double {
    func toUnitK() -> String {
        if self >= 1000 {
            let temp = self / 1000
            return "\(floor(temp * 10) / 10)K"
        }
        return "\(self)"
    }
}
