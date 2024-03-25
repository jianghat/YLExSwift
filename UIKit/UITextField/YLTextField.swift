//
//  YLTextField.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/26.
//

import UIKit

class YLTextField: UITextField {
    var allowSelect: Bool = true
    
    convenience init(font: UIFont, textColor: UIColor) {
        self.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.clearButtonMode = .whileEditing
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (allowSelect && action != #selector(UIResponderStandardEditActions.delete(_:))) {
            return true
        } else {
            return false
        }
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        self.changeClearButtonImage()
    }
    
    @objc func changeClearButtonImage() {
        if let btn = self.value(forKey: "_clearButton") as? UIButton {
            btn.setImage(YLImageNamed("textField_clear"), for: .normal)
        } else {
            var btn: UIButton?
            for item in self.subviews {
                if item is UIButton {
                    btn = item as? UIButton
                    break
                }
            }
            if btn != nil {
                btn?.setImage(YLImageNamed("textField_clear"), for: .normal)
            }
        }
    }
}
