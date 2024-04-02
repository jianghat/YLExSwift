//
//  YLAppInfo.swift
//  Driver
//
//  Created by ym on 2020/9/27.
//  Copyright © 2020 edonesoft. All rights reserved.
//

import UIKit

class YLAppInfo: NSObject {
    class var shared: YLAppInfo {
        struct Static {
            static let sharedInstance = YLAppInfo()
        }
        return Static.sharedInstance
    }
    
    private override init() {}
    
    //MARK:当前版本的app是否第一次使用
    func currentAppVersionFirstLaunchStatus() -> Bool {
        let userDefaults = Foundation.UserDefaults.standard
        let key = "\(YLBundleShortVersion)_FirstLoad"
        if userDefaults.bool(forKey: key) == false {
            return true
        }
        return false
    }
    
    func setCurrentAppVersionFirstLaunchStatus(_ status: Bool) {
        let userDefaults = Foundation.UserDefaults.standard
        let key = "\(YLBundleShortVersion)_FirstLoad"
        userDefaults.set(status, forKey: key)
    }
}
