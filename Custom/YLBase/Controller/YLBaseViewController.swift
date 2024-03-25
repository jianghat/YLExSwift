//
//  BaseViewController.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/4.
//

import UIKit
import Alamofire
import EmptyDataSet_Swift

class YLBaseViewController: UIViewController {
    private let titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: kHarmonyOSBoldFont(16)]
    
    var isLoading: Bool = true {
        didSet {
            reloadEmptyDataSet()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController?.viewControllers.count > 1 {
            setLeftBarButtonItem(imageName: YLImageNamed("nav_back")) {[weak self] sender in
                self?.popViewController()
            }
        }
        changeTheme()
    }
    
    func reloadEmptyDataSet() {
        
    }
    
    func emptyDataSetConfig() -> EmptyDataSetConfig {
        let config = EmptyDataSetConfig()
        config.title = "暂无数据"
        config.image = YLImageNamed("empty_icon")
        return config
    }
    
    func changeTheme() {
        YLNotificationCenter.yl_addObserver(self,
                                            selector: #selector(handleChangeThemeNotify(_:)),
                                            name: ThemeNoticationName,
                                            object: nil)
        ThemeManager.themeUpdate()
    }
    
    @objc func handleChangeThemeNotify(_ notification: NSNotification) {
        guard let theme = notification.object as? ThemeProtocol else {
            return
        }
        view.backgroundColor = theme.backgroundColor
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = titleTextAttributes
            if (ThemeManager.shared().themeName == "dark") {
                appearance.backgroundColor = YLHEXColor("#16161E")
            } else {
                appearance.backgroundColor = YLHEXColor("#16161E")
            }
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
            if (ThemeManager.shared().themeName == "dark") {
                UINavigationBar.appearance().barTintColor = YLHEXColor("#16161E")
            } else {
                UINavigationBar.appearance().barTintColor = YLHEXColor("#16161E")
            }
        }
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true);
    }
    
    deinit {
        YLNotificationCenter.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.string(forKey: "ThemeType") == "dark" {
            return .lightContent
        } else {
            return .default
        }
    }
    
    lazy var navgationBar: MyCustomNavigationBar = {
        let nagationBar = MyCustomNavigationBar()
        view.addSubview(nagationBar)
        return nagationBar
    }()
    
    private lazy var emptyDataConfig: EmptyDataSetConfig = {
        let config = emptyDataSetConfig()
        return config
    }()
}

extension YLBaseViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        if (isLoading) {
            return nil
        }
        let emptyView = EmptyCustomView()
        emptyView.verticalOffset = emptyDataConfig.verticalOffset
        emptyView.titleLabel.text = emptyDataConfig.title
        emptyView.imageView.image = emptyDataConfig.image
        emptyView.button.setTitleOfNormal(emptyDataConfig.buttonTitle ?? "")
        emptyView.button.isHidden = emptyDataConfig.buttonTitle == nil
        emptyView.button.setActionTouchUpInside {[weak self] sender in
            if let buttonAction = self?.emptyDataConfig.buttonAction {
                buttonAction(sender)
            }
        }
        return emptyView
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return emptyDataConfig.allowTouch
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}


