//
//  UILabel+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/9/27.
//

import UIKit

extension UILabel {
    class func label<T>(font: T, textColor: UIColor = .white) -> UILabel {
        let label = UILabel(frame: .zero)
        if let font = font as? UIFont {
            label.font = font
        } else if let size = font as? CGFloat  {
            label.font = UIFont.systemFont(ofSize: size)
        }
        label.textColor = textColor
        return label
    }
    
    func expectedWidth() -> CGFloat {
        self.numberOfLines = 1
        let text: NSString = self.text! as NSString
        let size = text.size(withAttributes: [NSAttributedString.Key.font : self.font!])
        return size.width
    }
}
