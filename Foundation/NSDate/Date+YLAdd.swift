//
//  NSDate+YLAdd.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/11.
//

import UIKit
import SwiftDate

extension Date {
    func toFormat(_ dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

extension String {
    static func minutesAndSeconds(seconds: Int) -> String {
        let minutes = (seconds) % 3600 / 60
        let second = (seconds) % 60
        let str  = String(format: "%02lu:%02lu",minutes, second)
        return str
    }
    
    static func ddHHMM(seconds: Int) -> String {
        let days = (seconds)/(24*3600)
        let hours = (seconds)%(24*3600)/3600
        let minutes = (seconds)%3600/60
        let str  = String(format: "%02lu天%02lu小时%02lu分", days, hours, minutes)
        return str
    }
    
    func toFormat(_ formatter: String) -> String {
      return self.toDate(region:.local)?.toFormat(formatter) ?? ""
    }
}
