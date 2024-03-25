//
//  YLBaseScrollView.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/20.
//

import UIKit

class YLBaseScrollView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            // 知识点：scrollView容器试图必须设置4个方向的约束，同时还要设置宽高
            make.edges.equalToSuperview()
            // 知识点：注意了，这里必须得给宽或高设置优先级，哪个方向要滚动，优先级就必须低
            make.width.equalTo(self)
            make.height.equalTo(self).priority(.low)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentInsetAdjustmentBehavior = .never
        self.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView(frame: .zero)
        scrollView.addSubview(contentView)
        return contentView
    }()
}
