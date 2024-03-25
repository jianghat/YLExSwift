//
//  YLLabel.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/26.
//

import UIKit

class YLLabel: UILabel {
    var padding: UIEdgeInsets = .zero
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        rect.size.width += padding.left + padding.right
        rect.size.height += padding.top + padding.bottom
        return rect
    }
}
