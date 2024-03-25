//
//  YLBaseWebViewController.swift
//  gamefi-ios
//
//  Created by ym on 2020/9/30.
//

import UIKit
import WebKit

class YLBaseWebViewController: YLBaseViewController {
    var url: String = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(url: String) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
//    deinit {
//        webView.navigationDelegate = nil
//        webView.uiDelegate = nil
//    }
    
    func setupConstraints() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
//    lazy var loadingView: WebLoadingView = {
//        let loadingView = WebLoadingView()
//        view.addSubview(loadingView)
//        return loadingView
//    }()
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.websiteDataStore = .nonPersistent()
        
        // 设置偏好设置
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = false
        config.preferences = preferences
        
        // 通过JS与webview内容交互
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        
        let wkWebView = WKWebView(frame: .zero, configuration: config)
        wkWebView.scrollView.backgroundColor = YLHEXColor("#16161E")
        wkWebView.scrollView.contentInsetAdjustmentBehavior = .never
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.backgroundColor = .clear
        wkWebView.allowsLinkPreview = false
        wkWebView.isOpaque = false
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        view.addSubview(wkWebView)
        return wkWebView
    }()
}

extension  YLBaseWebViewController: WKNavigationDelegate, WKUIDelegate {
    
}
