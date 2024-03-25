//
//  YLAddressTableViewCell.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/18.
//

import UIKit

class YLAddressTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.label(font: kHarmonyOSFont(14), textColor: .white)
        return label
    }()
}
