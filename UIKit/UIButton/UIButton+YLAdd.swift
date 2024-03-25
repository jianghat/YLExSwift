//
//  UIButton+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/9/27.
//

import UIKit

extension UIButton {
    private struct YLUIButtonRuntimeKey {
        static let KEY_Action = UnsafeRawPointer(bitPattern: "buttonBlockKey".hashValue)!
    }
    
    private var blockTarget: YLBlockTarget? {
        get {
            return objc_getAssociatedObject(self, YLUIButtonRuntimeKey.KEY_Action) as? YLBlockTarget
        }
        set {
            objc_setAssociatedObject(self, YLUIButtonRuntimeKey.KEY_Action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addTarget(newValue, action: #selector(newValue?.invoke(_:)), for: .touchUpInside)
        }
    }
    
    class func button(title: String, font: UIFont, actionBlock: @escaping YLSenderBlock) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setFontOfSize(font)
        button.setActionTouchUpInside(actionBlock)
        return button
    }
    
    class func button(title: String, font: UIFont) -> UIButton {
        let button = UIButton()
        button.setTitleOfNormal(title)
        button.setFontOfSize(font)
        return button
    }
    
    class func button(title: String, font: CGFloat, bgColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitleOfNormal(title)
        button.setFontOfSize(font)
        button.setBackgroundColor(bgColor)
        return button
    }
    
    class func button(title: String = "", image: UIImage? = nil, actionBlock: @escaping YLSenderBlock) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.setActionTouchUpInside(actionBlock)
        return button
    }
    
    func setActionTouchUpInside(_ touchUpInside: @escaping YLSenderBlock) {
        let target = YLBlockTarget(block: touchUpInside)
        self.blockTarget = target
    }

    /*
     *  @brief  设置字体
     *
     *  @param size 字体或字号
     */
    func setFontOfSize<T>(_ size: T) {
        if size is UIFont {
            self.titleLabel?.font = size as? UIFont
        } else {
            self.titleLabel?.font = UIFont.systemFont(ofSize: size as! CGFloat)
        }
    }
    
    /*
     *  @brief  设置不同状态下文本内容
     *
     *  @param title 文本
     */
    func setTitle(_ title: String, state: UIControl.State = .normal) {
        self.setTitle(title, for: state)
    }
    
    /*
     *  @brief  设置常规状态下文本内容
     *
     *  @param title 文本
     */
    func setTitleOfNormal(_ title: String) {
        self.setTitle(title, for: UIControl.State.normal)
    }

    /*
     *  @brief  设置高亮状态下文本内容
     *
     *  @param title 文本
     */
    func setTitleOfHighlighted(_ title: String) {
        self.setTitle(title, for: UIControl.State.highlighted)
    }

    /*
     *  @brief  设置Disabled状态下文本内容
     *
     *  @param title 文本
     */
    func setTitleOfDisabled(_ title: String) {
        self.setTitle(title, for: UIControl.State.disabled)
    }
    
    /*
     *  @brief  设置不同状态下文本颜色
     *
     *  @param color 颜色
     */
    func setColorOfState(_ color : UIColor, state: UIControl.State) {
        self.setTitleColor(color, for: state)
    }
    
    /*
     *  @brief  设置常规状态下文本颜色
     *
     *  @param color 颜色
     */
    func setColorOfNormal(_ color : UIColor) {
        self.setTitleColor(color, for: UIControl.State.normal)
    }

    /*
     *  @brief  设置选中状态下文本颜色
     *
     *  @param color 颜色
     */
    func setColorOfSelected(_ color : UIColor) {
        self.setTitleColor(color, for: UIControl.State.selected)
    }

    /*
     *  @brief  设置高亮状态下文本颜色
     *
     *  @param color 颜色
     */
    func setColorOfHighlighted(_ color : UIColor) {
        self.setTitleColor(color, for: UIControl.State.highlighted)
    }

    /*
     *  @brief  设置不同状态下图片内容
     *
     *  @param imageName 图片
     */
    func setImage<T>(_ imageOrName: T?, state: UIControl.State = .normal) {
        if let image = imageOrName as? UIImage {
            self.setImage(image, for: state)
        } else if let name = imageOrName as? String {
            self.setImage(UIImage(named: name), for: state)
        } else {
            self.setImage(nil, for: state)
        }
    }
    
    /*
     *  @brief  设置常规状态下图片内容
     *
     *  @param imageName 图片
     */
    func setImageOfNormal<T>(_ imageOrName: T?) {
        setImage(imageOrName, state: .normal)
    }
    
    /*
     *  @brief  设置高亮状态下图片内容
     *
     *  @param imageName 图片
     */
    func setImageOfHighlighted<T>(_ imageOrName: T?) {
        setImage(imageOrName, state: .highlighted)
    }

    /*
     *  @brief  设置选择状态下图片内容
     *
     *  @param imageName 图片
     */
    func setImageOfSelected<T>(_ imageOrName: T?) {
        setImage(imageOrName, state: .selected)
    }
    
    /*
     *  @brief  设置不同状态下图片内容
     *
     *  @param imageName 图片
     */
    func setBackgroundImage<T>(_ imageOrName: T?, state: UIControl.State = .normal) {
        if let image = imageOrName as? UIImage {
            self.setBackgroundImage(image, for: state)
        } else if let name = imageOrName as? String {
            self.setBackgroundImage(UIImage(named: name), for: state)
        } else {
            self.setBackgroundImage(nil, for: state)
        }
    }
    
    /*
     *  @brief  设置常规状态下图片内容
     *
     *  @param imageName 图片
     */
    func setBackgroundImageOfNormal<T>(_ imageOrName: T?) {
        setBackgroundImage(imageOrName, state: .normal)
    }
    /*
     *  @brief  设置高亮状态下图片内容
     *
     *  @param imageName 图片
     */
    func setBackgroundImageOfHighlighted<T>(_ imageOrName: T?) {
        setBackgroundImage(imageOrName, state: .highlighted)
    }
    
    /*
     *  @brief  设置不同状态下背景颜色
     *
     *  @param color 颜色
     */
    func setBackgroundColor(_ color: UIColor, state: UIControl.State = .normal) {
        self.setBackgroundImage(UIImage.imageWithColor(color), for: state)
    }
}
