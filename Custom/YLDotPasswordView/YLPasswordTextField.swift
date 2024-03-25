//
//  YLPasswordTextField.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/18.
//

import UIKit

class YLPasswordTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearsOnBeginEditing = false
        self.isSecureTextEntry = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.hideMenu()
        return false
    }
}
