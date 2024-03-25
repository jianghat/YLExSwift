//
//  YLActionSheetHeaderView.swift
//  Driver
//
//  Created by ym on 2020/9/28.
//

import UIKit

class YLActionSheetHeaderView: UIView {
    /*!
     *  @brief  背景
     */
    public private (set) var bgView: UIImageView?

    /*!
     *  @brief  中间文本
     */
    public private (set) var titleLabel: UILabel?

    /*!
     *  @brief  左边按钮
     */
    public private (set) var cancelButton: UIButton?

    /*!
     *  @brief  右边按钮
     */
    public private (set) var doneButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView?.snp.updateConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        cancelButton?.snp.updateConstraints({ (make) in
            make.left.equalToSuperview().offset(5)
            make.height.equalToSuperview()
            make.width.equalTo(50)
        })
        
        doneButton?.snp.updateConstraints({ (make) in
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview()
            make.width.equalTo(50)
        })
        
        titleLabel?.snp.updateConstraints({ (make) in
            make.left.equalTo(self.cancelButton!.snp.right).offset(5)
            make.right.equalTo(self.doneButton!.snp.left).offset(-5)
            make.height.equalToSuperview()
            make.width.equalTo(50)
        })
    }
    
    func setupView() {
        self.bgView = UIImageView(frame: self.bounds)
        self.bgView?.backgroundColor = YLHEXColor("E4F5F1")
        self.addSubview(self.bgView!)
        
        self.cancelButton = UIButton()
        self.cancelButton?.backgroundColor = UIColor.clear;
        self.cancelButton?.titleLabel!.font = UIFont.systemFont(ofSize: 15);
        self.cancelButton?.setImageOfNormal("actionSheet_btn_cancel")
        self.addSubview(self.cancelButton!)
        
        self.doneButton = UIButton()
        self.doneButton?.backgroundColor = UIColor.clear;
        self.doneButton?.titleLabel!.font = UIFont.systemFont(ofSize: 15);
        self.doneButton?.setImageOfNormal("actionSheet_btn_confirm")
        self.addSubview(self.doneButton!)
        
        self.titleLabel = UILabel.label(font: 17, textColor: YLThemeBlueColor)
        self.titleLabel?.textAlignment = .center
        self.addSubview(self.titleLabel!)
    }
}
