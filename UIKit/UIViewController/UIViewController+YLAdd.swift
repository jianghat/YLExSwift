//
//  UIViewController+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/9/30.
//

import UIKit

enum YLItemPosition {
    case rightItem
    case leftItem
}

extension UIViewController {
    class func currentViewController (base: UIViewController? = UIApplication.shared.windows[0].rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    func currentViewController () -> UIViewController? {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.currentViewController()
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.currentViewController()
        }
        if let presented = self.presentedViewController {
            return presented.currentViewController()
        }
        return self
    }
    
    /*
     *  @brief  导航栏标题
     *
     *  @param title        标题
     */
    func setNavigationTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    /*
     *  @brief  显示导航栏左边视图图片
     *
     *  @param imageName        图片or名称
     *  @param actionBlock      回调函数
     *
     *  @return UIButton
     */
    @discardableResult func setLeftBarButtonItem(imageName: Any, actionBlock: @escaping YLSenderBlock) -> UIButton {
        return setLeftBarButtonItem(imageName: imageName, highlightedName: imageName, actionBlock: actionBlock)
    }
    
    @discardableResult func setLeftBarButtonItem(imageName: Any, highlightedName: Any?, actionBlock: @escaping YLSenderBlock) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: YLNavItemWidth, height: YLNavHeight));
        if imageName is UIImage {
            button.setImage(imageName as? UIImage, for: .normal)
        } else {
            button.setImage(YLImageNamed(imageName as? String), for: .normal)
        }
        
        if highlightedName is UIImage {
            button.setImage(highlightedName as? UIImage, for: .highlighted)
        } else {
            button.setImage(YLImageNamed(highlightedName as? String), for: .highlighted)
        }
        
        button.setBlockFor(.touchUpInside) { (sender: Any) in
            let btn: UIButton = sender as! UIButton
            actionBlock(btn);
        }
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: button), animated: false)
        return button
    }
    
    /*
     *  @brief  显示导航栏左边视图图片
     *
     *  @param imageName        图片or名称
     *  @param actionBlock      回调函数
     *
     *  @return UIButton
     */
    @discardableResult func setRightBarButtonItem(imageName: Any, actionBlock: @escaping YLSenderBlock) -> UIButton {
        return setRightBarButtonItem(imageName: imageName, highlightedName: imageName, actionBlock: actionBlock)
    }
    
    @discardableResult func setRightBarButtonItem(imageName: Any, highlightedName: Any?, actionBlock:@escaping YLSenderBlock) -> UIButton {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: YLNavItemWidth, height: YLNavHeight));
        if imageName is UIImage {
            button.setImage(imageName as? UIImage, for: .normal)
        } else {
            button.setImage(YLImageNamed(imageName as? String), for: .normal)
        }
        
        if highlightedName is UIImage {
            button.setImage(highlightedName as? UIImage, for: .highlighted)
        } else {
            button.setImage(YLImageNamed(highlightedName as? String), for: .highlighted)
        }
        button.setBlockFor(UIControl.Event.touchUpInside) { sender in
            let btn = sender as! UIButton
            actionBlock(btn)
        }
        navigationItem.setRightBarButton(UIBarButtonItem(customView: button), animated: false)
        return button
    }
    
    @discardableResult func setNavigationBarButtonItem(_ title: String?, color: UIColor = .white, imageName: String? = nil, position: YLItemPosition, actionBlock:@escaping YLSenderBlock) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: YLNavHeight))
        button.setBlockFor(.touchUpInside) { sender in
            let btn = sender as! UIButton
            actionBlock(btn)
        }
        button.contentHorizontalAlignment = .center
        button.setTitleOfNormal(title ?? "")
        button.setTitleOfHighlighted(title ?? "")
        button.setColorOfNormal(color)
        button.setFontOfSize(15)
        
        if (imageName != nil) {
            button.setImageOfNormal(imageName!)
            button.setImageOfHighlighted(imageName!)
        }
        
        let titleSize = (button.titleLabel?.intrinsicContentSize)!
        let imageSize = (button.imageView?.frame.size)!
        let space: CGFloat = 1.0
        
        button.width = max(titleSize.width + imageSize.width + space, YLNavItemWidth)
        
        if (imageName != nil && title != nil) {
            button.imageEdgeInsets = UIEdgeInsets.init(top: -titleSize.height, left: 0, bottom: 0, right: -titleSize.width)
            button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageSize.width, bottom: -imageSize.height-space, right: 0)
        }
        
        if position == .leftItem {
            navigationItem.setLeftBarButton(UIBarButtonItem(customView: button), animated: false)
        } else {
            navigationItem.setRightBarButton(UIBarButtonItem(customView: button), animated: false)
        }
        return button
    }
    
    /*
     *  @brief  显示导航栏左边文字
     *
     *  @param title            名称
     *  @param actionBlock      回调函数
     */
    func setLeftBarTitleItem(title: String, actionBlock:YLSenderBlock!) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItem(title:title, actionBlock: actionBlock!)
    }
    
    /*
     *  @brief  显示导航栏右边文字
     *
     *  @param title            名称
     *  @param actionBlock      回调函数
     */
     func setRightBarTitleItem(title: String, actionBlock:YLSenderBlock!) {
         navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItem(title:title, actionBlock: actionBlock)
    }
    /**
     * 将导航条的背景色设置为透明*
     */
    func setNavigationBarTranslucent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

