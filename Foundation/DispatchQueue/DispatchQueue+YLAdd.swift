//
//  DispatchQueue+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/10/9.
//

import Foundation

typealias Task = (_ cancel: Bool) -> Void

extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token);
        block()
    }
    
    class func async_main(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: {
                block()
            })
        }
    }
    
    class func async_after(_ deadline: DispatchTime, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            block()
        }
    }
    
    class func async_global(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            block()
        }
    }
    
    @discardableResult  class func delay(_ time: TimeInterval, task: @escaping () -> Void) -> Task? {
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (() -> Void)? = task
        var result: Task?
        
        let delayedClosure: Task = { cancel in
            if let closure = closure {
                if (!cancel) {
                    DispatchQueue.main.async(execute: closure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let result = result {
                result(false)
            }
        }
        return result
    }
}
