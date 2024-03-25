//
//  YLAlertView.swift
//  Driver
//
//  Created by ym on 2020/9/28.
//

import UIKit

typealias YLButtonTappedIndexBlock = (_ index: Int) -> Void

class YLAlertView: YLBasePopView {
    private let maxWidth = UIScreen.main.bounds.size.width - 48
    public var buttonTappedIndexBlock: YLButtonTappedIndexBlock?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMaskDismiss = false
    }
    
    convenience init(title: String?, message: String?, cancelTitle: String?, okTitle: String?) {
        self.init(frame: CGRect.zero)
        titleLabel.text = title
        messageLabel.text = message
        cancelButton.setTitleOfNormal(cancelTitle ?? "取消")
        doneButton.setTitleOfNormal(okTitle ?? "确认")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        contentView = UIView(frame: .zero)
        contentView.backgroundColor = GreyColor
        contentView.addSubViews([titleLabel, messageLabel, cancelButton, doneButton])
    }
    
    override func updateConstraints() {
        contentView.snp.updateConstraints{ (make) in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.updateConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        
        messageLabel.snp.updateConstraints{ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.width.lessThanOrEqualTo(YLScreenWidth - 60 - 32)
            make.left.greaterThanOrEqualTo(16)
            make.right.lessThanOrEqualTo(-16)
            make.centerX.equalToSuperview()
        }

        cancelButton.snp.updateConstraints{ (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(30)
            make.right.equalTo(contentView.snp.centerX).offset(-8)
            make.left.greaterThanOrEqualTo(16)
            make.size.equalTo(CGSize(width: 113, height: 36))
            make.bottom.lessThanOrEqualTo(-24)
        }

        doneButton.snp.updateConstraints{ (make) in
            make.left.equalTo(contentView.snp.centerX).offset(8)
            make.size.centerY.equalTo(cancelButton)
            make.right.lessThanOrEqualTo(-16)
        }
        super.updateConstraints()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.label(font: kDINCondBoldFont(18), textColor: .white)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel.label(font: 14, textColor: White6Color)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.button(title: "", font: kArialFont(16))
        button.setBackgroundColor(YLHEXColor("#292838"))
        button.setColorOfNormal(White6Color)
        button.setCornerRadius(4)
        button.setActionTouchUpInside { [weak self] (sender) in
            self?.dismiss()
            self?.buttonTappedIndexBlock?(0)
        }
        return button
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton.button(title: "", font: kArialFont(16))
        button.setBackgroundColor(GreenColor)
        button.setColorOfNormal(.black)
        button.setCornerRadius(4)
        button.setActionTouchUpInside { [weak self] (sender) in
            self?.dismiss()
            self?.buttonTappedIndexBlock?(1)
        }
        return button
    }()
}
