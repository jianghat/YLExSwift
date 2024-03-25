//
//  UIView+YLCornerSet.swift
//  Driver
//
//  Created by ym on 2020/9/27.
//

import UIKit

enum YLBorderDirection: Int {
    case top = 10001
    case left
    case bottom
    case right
    case all
}

extension UIView {
    class func setCornerRadius(_ target: [UIView], radius:CGFloat) {
        for item in target {
            item.layer.cornerRadius = radius
            item.layer.masksToBounds = true
        }
    }
    
    class func setCornerRadius(_ target: [UIView], radius:CGFloat, borderColor:UIColor, borderWidth:CGFloat) {
        for item in target {
            item.layer.cornerRadius = radius
            item.layer.masksToBounds = true
            item.layer.borderWidth = borderWidth
            item.layer.borderColor = borderColor.cgColor
        }
    }
    
    func setCornerRadius(_ radius : CGFloat) {
        setCornerRadius(radius, borderColor: .clear)
    }
    
    func setCornerRadius(_ radius : CGFloat, borderColor: UIColor) {
        setCornerRadius(radius, borderColor: borderColor, borderWidth: 0)
    }
    
    func setCornerRadius(_ radius : CGFloat, borderWidth: CGFloat) {
        setCornerRadius(radius, borderColor: .clear, borderWidth: borderWidth)
    }
    
    func setCornerRadius(_ radius : CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = radius
    }
    
    /* 部分圆角 UIView.setRoundCorners(corners: [UIRectCorner.topLeft,UIRectCorner.topRight], with: 10) */
    func setRoundCorners(_ corners: UIRectCorner, width radii: CGFloat) {
        let bezierpath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = bezierpath.cgPath
        self.layer.mask = shape
    }
    
    func setRoundCorners(_ corners: UIRectCorner, bounds: CGRect, width radii: CGFloat) {
        let bezierpath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let shape = CAShapeLayer()
        shape.path = bezierpath.cgPath
        self.layer.mask = shape
    }
    
    func setBorderLine(direction: YLBorderDirection, color: UIColor, width: CGFloat) {
        var splitView = self.viewWithTag(direction.rawValue) ?? UIView()
        splitView.backgroundColor = color
        splitView.tag = direction.rawValue
        if splitView.superview == nil {
            self.addSubview(splitView)
        }
        switch direction {
        case .top:
            splitView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(width)
            }
        case .left:
            splitView.snp.makeConstraints { (make) in
                make.top.left.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
        case .bottom:
            splitView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(width)
            }
        case .right:
            splitView.snp.makeConstraints { (make) in
                make.right.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
        case .all:
            setCornerRadius(0, borderColor: color, borderWidth: width)
        }
    }
}

