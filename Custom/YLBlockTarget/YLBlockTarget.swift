//
//  YLBlockTarget.swift
//  Driver
//
//  Created by ym on 2020/10/12.
//

import UIKit

class YLBlockTarget : NSObject {
    var block: YLSenderBlock?
    
    override init() {
        super.init()
    }
    
    convenience init(block: @escaping YLSenderBlock) {
        self.init()
        self.block = block
    }
    
   @objc func invoke(_ sender: Any) {
        if block != nil {
            block!(sender)
        }
    }
}
