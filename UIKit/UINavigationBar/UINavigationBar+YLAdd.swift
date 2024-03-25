//
//  UINavigationBar+YLAdd.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/4.
//

import UIKit

extension UINavigationBar {
    private struct YLUINavigationBarRuntimeKey {
        static let KEY_Action = UnsafeRawPointer(bitPattern: "YLUINavigationBarRuntimeKey".hashValue)!
    }
    
    func overlay() -> UIView? {
        return objc_getAssociatedObject(self, YLUINavigationBarRuntimeKey.KEY_Action) as? UIView;
    }
    
    func setOverlay(_ overlay: UIView) {
        objc_setAssociatedObject(self, YLUINavigationBarRuntimeKey.KEY_Action, overlay, .OBJC_ASSOCIATION_RETAIN);
    }
    
    func yl_setBackgroundColor(_ backgroundColor: UIColor) {
        if (self.overlay() == nil) {
            self.setBackgroundImage(UIImage(), for: .default)
            self.alpha = 0;
            // insert an overlay into the view hierarchy
            let overlay = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: self.bounds.size.height + 20))
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight];
            self.insertSubview(overlay, at: 0)
            setOverlay(overlay)
        }
        self.overlay()?.backgroundColor = backgroundColor;
    }
}
