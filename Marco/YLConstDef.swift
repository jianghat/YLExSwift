//
//  YLConstDef.swift
//  Driver
//
//  Created by ym on 2020/9/25.
//  Copyright © 2020 edonesoft. All rights reserved.
//

import UIKit
import AVFoundation

typealias YLResultBlock = (_ result: Any) -> Void
typealias YLSenderBlock = (_ sender: Any) -> Void

//数字
let YLNum: String = "0123456789"
//字母
let YLAlpha: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
let YLAlphaNum: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

let YLApplictionShared = UIApplication.shared
let YLAppDelegate = YLApplictionShared.delegate as! AppDelegate
let YLKeyWindow = YLApplictionShared.windows[0]
let YLNotificationCenter = NotificationCenter.default
let YLUserDefaults = UserDefaults.standard
let YLMainBundle = Bundle.main

// MARK: info.plist
let YLInfoDictionary = YLMainBundle.infoDictionary!

/* CFBundleDisplayName*/
let YLBundleDisplayName: String = YLInfoDictionary["CFBundleDisplayName"] as! String
let YLProjectName: String = YLInfoDictionary[kCFBundleExecutableKey as String] as! String
let YLBundleName: String = YLInfoDictionary[kCFBundleNameKey as String] as! String
let YLBundleIdentifier: String = Bundle.main.bundleIdentifier!
let YLBundleShortVersion: String = YLInfoDictionary["CFBundleShortVersionString"] as! String
let YLBundleVersion: String = YLInfoDictionary["CFBundleVersion"] as! String

// MARK: Device
let YLCurrentDevice = UIDevice.current
let YLDeviceName: String = YLCurrentDevice.name
let YLDeviceSystemName: String = YLCurrentDevice.systemName
let YLDeviceVersion = (YLCurrentDevice.systemVersion as NSString).floatValue
let YLDeviceModel: String = YLCurrentDevice.model
let YLDeviceLanguage: String = Locale.preferredLanguages.first!
let YLLocaleIdentifier: String = Locale.current.identifier

let YL_IS_IPhoneX_All = UIDevice.isIPhoneXSeries()

// MARK: UI
let YLScreenBounds = UIScreen.main.bounds
let YLScreenSize = YLScreenBounds.size
let YLScreenWidth = YLScreenSize.width
let YLScreenHeight = YLScreenSize.height
let YLScale = UIScreen.main.scale

let YLNavItemWidth: CGFloat = 36
let YLNavHeight: CGFloat = 44
let YLNavBarHeight: CGFloat = (YL_IS_IPhoneX_All ? 88 : 64)
let YLTabbarHeight: CGFloat = (YL_IS_IPhoneX_All ? 83 : 49)
let YLStatusBarHeight: CGFloat = (YL_IS_IPhoneX_All ? 40 : 20)
let YLSafeAreaTop: CGFloat = (YLStatusBarHeight+YLNavHeight)
let YLSafeAreaHeight: CGFloat = (YLScreenHeight-YLSafeAreaTop)
let YLSafeAreaHeightWithTabbar: CGFloat = (YLScreenHeight-YLSafeAreaTop-YLTabbarHeight)
//全面屏iPhoneTabBar额外的高度
let YLFullTabbarExtraHeight: CGFloat = (YL_IS_IPhoneX_All ? 34 : 0)


func YLDesignFit(_ width: CGFloat) -> CGFloat {
    let mainSize =  UIScreen.main.bounds.size
    let min = mainSize.height < mainSize.width ? mainSize.height : mainSize.width
    return (min / 375) * width
}

func YLDesignFit(_ rect: CGRect) -> CGRect {
    let fixY = rect.origin.y - YLNavBarHeight
    return CGRect(x: rect.origin.x, y: fixY, width: rect.size.width, height: rect.size.height)
}

func YLSetTabbarSelectedIndex(_ index: Int) {
    if let currentNav = UIViewController.currentViewController()?.navigationController {
        if (currentNav.viewControllers.count > 1) {
            currentNav.popToRootViewController(animated: false)
        }
    }
    guard let tabBarVc = UIApplication.shared.windows[0].rootViewController as? UITabBarController else { return }
    DispatchQueue.async_after(.now() + 0.01) {
        tabBarVc.selectedIndex = index
    }
}

func YLAudioServicesPlayAlertSound(_ path: String) {
    var systemSoundID: SystemSoundID = 0
    AudioServicesCreateSystemSoundID(URL(fileURLWithPath: path) as CFURL, &systemSoundID)
    AudioServicesPlayAlertSound(SystemSoundID(systemSoundID))
}

// MARK: FONT

func kArialFont(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

func kArialBoldFont(_ size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

func kHarmonyOSFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "HarmonyOS_Sans_SC", size: size) ?? kArialFont(size)
}

func kHarmonyOSMediumFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "HarmonyOS_Sans_SC_Medium", size: size) ?? kArialFont(size)
}

func kHarmonyOSBoldFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "HarmonyOS_Sans_SC_Bold", size: size) ?? kArialBoldFont(size)
}

func kPingFangFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "PingFang-SC", size: size) ?? kHarmonyOSFont(size)
}

func kPingFangMediumFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "PingFang-SC-Medium", size: size) ?? kHarmonyOSMediumFont(size)
}

func kPingFangBoldFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "PingFang-SC-Bold", size: size) ?? kHarmonyOSBoldFont(size)
}

func kDINCondFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "DINCond-Regular", size: size) ?? kPingFangFont(size)
}

func kDINCondBoldFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: "DINCond-Bold", size: size) ?? kPingFangBoldFont(size)
}

// MARK: COLOR
let YLThemeBlueColor = UIColor.colorWithHexString("1BC5E8")

// MARK: UIIMage

func YLImageNamed(_ imageName: String?) -> UIImage {
    guard let name = imageName else { return UIImage() }
    return UIImage(named: name) ?? UIImage()
}

func YLImageOfFile(_ imageName: String) -> UIImage {
    let file = "\(YLMainBundle.bundlePath)/\(imageName)"
    guard let image = UIImage(contentsOfFile: file) else { return UIImage() }
    return image.withRenderingMode(.alwaysOriginal)
}

func YLMainBundlePath(_ name: String, ofType: String? = nil) -> String {
    return YLMainBundle.path(forResource: name, ofType: ofType) ?? ""
}
