//
//  YLTextView.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/18.
//

import UIKit

class YLTextView: UITextView, UITextViewDelegate {
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var value: String? {
        set {
            if (newValue == nil || newValue?.length == 0) {
                placeholderLabel.text = placeholder
            } else {
                placeholderLabel.text = ""
            }
            self.text = newValue
        }
        get {
            return self.text
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.backgroundColor = .clear
        self.textColor = .white
        self.delegate =  self
        self.addSubview(placeholderLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = self.width - 10
        placeholderLabel.snp.updateConstraints { make in
            make.top.left.equalTo(6)
        }
    }
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel.label(font: kHarmonyOSFont(14), textColor: White4Color)
        label.numberOfLines = 0
        return label
    }()
}

extension YLTextView{
    func textViewDidChange(_ textView: UITextView) {
        self.value = textView.text
    }
}
