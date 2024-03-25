//
//  UIControl+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/11/30.
//

import UIKit

extension UIControl {
    private struct YLControlKey {
        static let KEY_Action = UnsafeRawPointer(bitPattern: "UIControl".hashValue)!
    }
    
    func controlEvents(controlEvents: UIControl.Event, handler: @escaping YLSenderBlock) {
        let target = YLBlockTarget.init(block: handler);
        objc_setAssociatedObject(self, YLControlKey.KEY_Action, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.addTarget(self, action: #selector(actionFunction), for: controlEvents);
    }
    
    @objc func actionFunction() {
        let target = objc_getAssociatedObject(self, YLControlKey.KEY_Action) as? YLBlockTarget
        if target?.block != nil {
            target!.block!(self)
        }
    }
}

extension UIGestureRecognizer {
    private struct YLGestureRecognizerKey {
        static let KEY_Action = UnsafeRawPointer(bitPattern: "UIGestureRecognizer".hashValue)!
    }
    
    func gestureRecognizerHandle(handler: @escaping YLSenderBlock) {
        let target = YLBlockTarget.init(block: handler);
        objc_setAssociatedObject(self, YLGestureRecognizerKey.KEY_Action, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.addTarget(self, action: #selector(gestureActionFunction))
    }
    
    @objc func gestureActionFunction() {
        let target = objc_getAssociatedObject(self, YLGestureRecognizerKey.KEY_Action) as? YLBlockTarget;
        if target?.block != nil {
            target!.block!(self)
        }
    }
}

extension UIView {
    @discardableResult func addTapGestureRecognizer(handler: @escaping YLSenderBlock) -> UITapGestureRecognizer {
        return self.addTapGestureRecognizerNumberOfTap(numberOfTap: 1, handler: handler)
    }
    
    @discardableResult func addTapGestureRecognizerNumberOfTap(numberOfTap: Int, handler: @escaping YLSenderBlock) -> UITapGestureRecognizer {
        
        if !self.isUserInteractionEnabled {
            self.isUserInteractionEnabled = true
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer.init()
        tapGestureRecognizer.numberOfTapsRequired = numberOfTap
        tapGestureRecognizer.gestureRecognizerHandle { (gestureRecognizer) in
            handler(gestureRecognizer)
        };
        self.addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer
    }
    
    @discardableResult func addUIControlHandler(handler: @escaping YLSenderBlock) -> UIControl {
        let control = UIControl()
        control.backgroundColor = UIColor.clear
        self.insertSubview(control, at: 0)
        
        if (!self.isUserInteractionEnabled) {
            self.isUserInteractionEnabled = true
        }
        
        control.controlEvents(controlEvents: .touchUpInside) {[weak self] (_) in
            handler(self!)
        }
        
        control.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return control
    }
}


