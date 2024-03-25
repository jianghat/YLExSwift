//
//  YLBaseView.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/5.
//

import UIKit

class YLBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    func createUI() {
        
    }
    
    func setupConstraints() {
        
    }
}
