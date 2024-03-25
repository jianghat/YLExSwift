//
//  YLValid.swift
//  Driver
//
//  Created by ym on 2020/9/29.
//

import Foundation
import SwiftDate

extension String {
    func validateByRegex(_ regex: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    /**
     *  网址有效性
     */
    func isValidURL() -> Bool {
        let regex = "^((http)|(https))+:[^\\s]+\\.[^\\s]*$"
        return self.validateByRegex(regex)
    }
    
    /**
     *  手机
     */
    func isPhoneNum(areaCode: String) -> Bool {
        if (areaCode == "86") {
            let regex = "^1(3|4|5|7|8|9|6)\\d{9}$"
            return self.validateByRegex(regex)
        }
        if (areaCode == "852") {
            let regex = "^([5|6|9])\\d{7}$"
            return self.validateByRegex(regex)
        }
        if (areaCode == "853") {
            let regex = "^6\\d{7}$"
            return self.validateByRegex(regex)
        }
        if (areaCode == "886") {
            let regex = "^[0][9]\\d{8}$"
            return self.validateByRegex(regex)
        }
        return true
    }
    
    /**
     *  邮箱
     */
    func isEmailAddress() -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.validateByRegex(regex)
    }
    
    /**
     *  身份证
     */
    func isIDCardNumber() -> Bool {
        let regex = "^\\d{17}[0-9Xx]$";
        return self.validateByRegex(regex);
    }
    func isAdult() -> Bool {
        if self.count < 16 || self.isIDCardNumber() == false {
            return true
        }
        let year = Int(self.substring(rang: NSMakeRange(6, 4)))
        let month = Int(self.substring(rang: NSMakeRange(10, 2)))
        let day = Int(self.substring(rang: NSMakeRange(12, 2)))
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let calendar = Calendar.current
        guard let birthdayDate = calendar.date(from: components) else {
            return true
        }
        let nowDate = Date()
        if (nowDate.year - birthdayDate.year == 18) {
            if (nowDate.month - birthdayDate.month == 0) {
                if (nowDate.day - birthdayDate.day > 0) {
                    return false
                }
            } else if (nowDate.month - birthdayDate.month > 0) {
                return false
            }
            return true
        } else if (nowDate.year - birthdayDate.year > 18) {
            return false
        }
        return true
    }
    /**
     *  判断字符串是否为空
     */
    func isNullOrEmpty() -> Bool {
        return self.trimmingWhitespaceAndNewlines().length == 0
    }
    
    /**
     *  判断字符串是否为整型
     */
    func isPureInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /**
     *  判断是否为浮点型
     */
    func isPureFloat() -> Bool {
        if let _ = Double(self), let _ = Float(self) {
            return true
        }
        return false
    }
    
    /**
     *  判断是否为纯汉字
     */
    func isPureChinese() -> Bool {
        let regex: String = "[\\u4e00-\\u9fa5]+$"
        return self.validateByRegex(regex);
    }
    
    /**
     *  判断是否为表情符号
     */
    func isContainsEmoji() -> Bool {
        let regex = "[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]";
        return self.validateByRegex(regex);
    }
}

