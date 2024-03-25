//
//  UIBarButtonItem+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/10/10.
//

import UIKit

fileprivate struct YLBarButtonItemRuntimeKey {
    static let KEY_Action
        = UnsafeRawPointer(bitPattern: "KEY_YL_BarButtonItemKey".hashValue)!
}

extension UIBarButtonItem {
    private var blockTarget: YLBlockTarget? {
        get {
            return objc_getAssociatedObject(self, YLBarButtonItemRuntimeKey.KEY_Action) as? YLBlockTarget
        }
        set {
            objc_setAssociatedObject(self, YLBarButtonItemRuntimeKey.KEY_Action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.target = newValue
            self.action = #selector(newValue?.invoke(_:))
        }
    }
    
    class func barButtonItem(title: String, actionBlock: @escaping YLSenderBlock) -> UIBarButtonItem {
        let item = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        item.setTitleTextAttributes([.foregroundColor : UIColor.white, .font: kArialFont(16)], for: .normal)
        let target = YLBlockTarget.init(block: actionBlock)
        item.blockTarget = target
        return item
    }
    
    class func barButtonItem(imageName: String, actionBlock: @escaping YLSenderBlock) -> UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: nil, action: nil)
        let target = YLBlockTarget.init(block: actionBlock)
        item.blockTarget = target
        return item
    }
}
