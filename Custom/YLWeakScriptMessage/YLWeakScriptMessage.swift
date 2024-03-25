//
//  YLWeakScriptMessageDelegate.swift
//  gamefi-ios
//
//  Created by ym on 2024/1/6.
//

import UIKit
import WebKit

protocol YLWeakScriptMessageDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) -> Void
}

class YLWeakScriptMessage: NSObject, WKScriptMessageHandler {
    private var scriptDelegate: YLWeakScriptMessageDelegate?
    
    convenience init(delegate: YLWeakScriptMessageDelegate) {
        self.init()
        scriptDelegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}
