//
//  YLBaseCollectionViewCell.swift
//  gamefi-ios
//
//  Created by ym on 2024/1/22.
//

import UIKit

class YLBaseCollectionViewCell: UICollectionViewCell {
    
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
