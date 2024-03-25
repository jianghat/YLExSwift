//
//  YLDataPickerHeaderView.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/17.
//

import UIKit

class YLDataPickerHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([titleLabel, cancelButton, confirmButton, lineView])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        cancelButton.snp.updateConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(80)
        }
        titleLabel.snp.updateConstraints { make in
            make.center.equalToSuperview()
        }
        confirmButton.snp.updateConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        lineView.snp.updateConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0.5)
        }
        super.updateConstraints()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.label(font: kHarmonyOSBoldFont(16), textColor: .black)
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.button(title: "取消", font: kHarmonyOSFont(16))
        button.setColorOfNormal(.gray)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.button(title: "确定", font: kHarmonyOSFont(16))
        button.setColorOfNormal(YLRGB(46, 46, 236))
        return button
    }()
    
    lazy var lineView: UIView = {
        let lineV = UIView()
        lineV.backgroundColor = GreyColor
        return lineV
    }()
}
