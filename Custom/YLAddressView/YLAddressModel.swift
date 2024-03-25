//
//  YLAddressModel.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/18.
//

import UIKit
import HandyJSON

class YLAddressModel: HandyJSON {
    var parentCode: String?
    var code: String?
    var value: String?
    var children: [YLAddressModel]?
    
    required init() {}
}
