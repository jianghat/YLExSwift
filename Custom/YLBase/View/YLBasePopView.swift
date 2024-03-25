//
//  YLBasePopView.swift
//  Driver
//
//  Created by ym on 2020/9/28.
//

import UIKit

enum AlertAnimation {
    case None
    case Top
    case Bottom
    case Left
    case Right
    case Center
}

var NoticePopupCaches: [String: Any] = [:]

class YLBasePopView: UIView {
    var contentView: UIView = UIView() {
        didSet {
            contentView.setCornerRadius(self.cornerRadius)
            addSubview(contentView)
        }
    }
    
    /** contentView圆角值*/
    var cornerRadius: CGFloat = 8 {
        didSet {
            contentView.setCornerRadius(cornerRadius)
        }
    }
    
    var isMaskDismiss: Bool = true
    var cacheKey: String = ""
    
    private var animation: AlertAnimation = .None
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        controlView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
    }
    
    func show(animation: AlertAnimation, in view: UIView?) {
        if (cacheKey.count > 0) {
            NoticePopupCaches.updateValue(true, forKey: cacheKey)
        }
        self.animation = animation
        self.endEditing(true)
        if let superView = view {
            self.frame = superView.bounds
            superView.addSubview(self)
        } else {
            let window = UIApplication.shared.windows[0]
            window.addSubview(self)
        }
        self.contentView.alpha = 0
        self.layoutIfNeeded()
        
        DispatchQueue.async_main {
            let frame = self.contentView.frame
            switch self.animation {
            case .None:
                self.contentView.alpha = 1
            case .Top:
                self.contentView.top = self.frame.size.height - frame.size.height
                self.contentView.alpha = 1
                UIView.animate(withDuration: 0.25) {
                    self.contentView.frame = frame
                }
            case .Bottom:
                self.contentView.top = self.frame.height + frame.size.height
                self.contentView.alpha = 1
                UIView.animate(withDuration: 0.25) {
                    self.contentView.top = self.frame.height - frame.size.height
                }
            case .Left:
                self.contentView.frame = CGRect(x: self.frame.size.width - frame.size.width, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
                self.contentView.alpha = 1
                UIView.animate(withDuration: 0.25) {
                    self.contentView.frame = frame
                }
            case .Right:
                self.contentView.frame = CGRect(x: self.frame.size.width + frame.size.width, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
                self.contentView.alpha = 1
                UIView.animate(withDuration: 0.25) {
                    self.contentView.frame = frame
                }
            case .Center:
                UIView.animate(withDuration: 0.25) {
                    self.contentView.alpha = 1
                }
            }
        }
    }
    
    func show() {
        self.show(animation: .None)
    }
    
    func show(animation: AlertAnimation) {
        self.show(animation: animation, in: nil)
    }
    
    func dismiss() {
        self.dismiss(animation: self.animation) {}
    }
    
    func dismiss(complete: @escaping () -> Void) {
        self.dismiss(animation: self.animation, complete: complete)
    }
    
    func dismiss(animation: AlertAnimation, complete: @escaping () -> Void) {
        if (cacheKey.count > 0) {
            NoticePopupCaches.removeValue(forKey: cacheKey)
        }
        switch animation {
        case .Center:
            UIView.animate(withDuration: 0.25) {
                self.contentView.alpha = 0
            } completion: { finished in
                self.removeFromSuperview()
                complete()
            }
        case .None:
            self.removeFromSuperview()
            complete()
        case .Top:
            UIView.animate(withDuration: 0.25) {
                self.contentView.top = self.height - self.contentView.height
            } completion:{ finished in
                self.removeFromSuperview()
                complete()
            }
        case .Bottom:
            UIView.animate(withDuration: 0.25) {
                self.contentView.top = self.height + self.contentView.height
            } completion:{ finished in
                self.removeFromSuperview()
                complete()
            }
        case .Left:
            UIView.animate(withDuration: 0.25) {
                self.contentView.frame = CGRect(x: self.frame.size.width - self.contentView.frame.size.width, y: self.contentView.frame.origin.y, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            } completion: { finished in
                self.removeFromSuperview()
                complete()
            }
        case .Right:
            UIView.animate(withDuration: 0.25) {
                self.contentView.frame = CGRect(x: self.frame.size.width + self.contentView.frame.size.width, y: self.contentView.frame.origin.y, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            } completion:{ finished in
                self.removeFromSuperview()
                complete()
            }
        }
    }
    
    @objc func didReceiveTouchEvent(event: UIEvent) -> Void {
        if self.isMaskDismiss == true {
            self.dismiss { }
        }
    }
    
    private lazy var controlView: UIControl = {
        let controlV = UIControl(frame: UIScreen.main.bounds)
        controlV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controlV.backgroundColor = UIColor.clear
        controlV.addTarget(self, action: #selector(didReceiveTouchEvent(event:)), for: .touchDown)
        addSubview(controlV)
        return controlV
    }()
}

