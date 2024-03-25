//
//  YLBaseScollerViewController.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/18.
//

import UIKit

class YLBaseScrollViewController: YLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentV = UIView(frame: .zero)
        scrollView.addSubview(contentV)
        return contentV
    }()
}
