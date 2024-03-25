//
//  YLDotPasswordView.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/17.
//

import UIKit

class YLDotPasswordView: UIView {
    private var passwordDotsArray: [UILabel] = []
    private var passwordMargin: CGFloat = 5
    private var passwordLength: Int = 6
    let target = Delegate<Bool, Void>()
    var password: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        textField.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isFirstResponder == false) {
            becomeFirstResponder()
        }
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        textField.endEditing(force)
        return super.endEditing(force)
    }
    
    func setupUI() {
        for _ in 0 ..< passwordLength {
            let label = UILabel(frame: .zero)
            label.backgroundColor = YLHEXColor("#292838")
            label.textAlignment = .center
            label.font = kArialBoldFont(38)
            label.setCornerRadius(4, borderWidth: 1)
            label.textColor = .white
            addSubview(label)
            passwordDotsArray.append(label)
        }
    }
    
    func updateDotView(text: String) {
        for i in 0..<passwordLength {
            let label = passwordDotsArray[i]
            if (i < text.length) {
                label.text = "•"
            } else {
                label.text = nil
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let w = min(frame.size.width/CGFloat(passwordLength), frame.size.height)
        let h = w
        var dotX: CGFloat = 0
        for i in 0 ..< passwordLength {
            dotX = CGFloat(i) * (w + passwordMargin)
            let label = passwordDotsArray[i]
            label.frame = CGRectMake(dotX, 0, w, h)
        }
    }
    
    lazy var textField: YLPasswordTextField = {
        let textField = YLPasswordTextField()
        textField.backgroundColor = .clear
        textField.textColor = .clear
        textField.tintColor = .clear
        textField.delegate = self
        textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
}

extension YLDotPasswordView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tmpSet = CharacterSet(charactersIn: "0123456789")
        var result = true
        var i = 0
        while(i < string.length) {
            let str = string.substring(rang: NSMakeRange(i, 1))
            let range = str.rangeOfCharacter(from: tmpSet)
            if range == nil {
                result = false
                break
            }
            i+=1
        }
        return result
    }
    
    @objc func textEditingChanged(_ textField: UITextField) {
        var text = textField.text ?? ""
        if text.count > passwordLength {
            text = text.substring(rang: NSRange(location: 0, length: passwordLength))
            textField.text = text
        }
        updateDotView(text: text)
        password = text
        if (text.length >= passwordLength) {
            textField.resignFirstResponder()
            target.call(true)
        } else {
            target.call(false)
        }
    }
}

