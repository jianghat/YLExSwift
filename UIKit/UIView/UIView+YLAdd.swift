//
//  UIView+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/9/27.
//

import UIKit

extension UIView {
    var viewController: UIViewController? {
        get {
            for view in sequence(first: self.superview, next: {$0?.superview}) {
                if let responder = view?.next {
                    if responder.isKind(of: UIViewController.self) {
                        return responder as? UIViewController
                    }
                }
            }
            return nil
        }
    };
    
    // 倒计时
    @discardableResult
    class func startCountDown(_ timeOut: Int, runBlock: @escaping (Int) -> Void, finshBlock: @escaping () -> Void) -> DispatchSourceTimer {
        var timeout: Int = timeOut; //倒计时时间
        let timer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global());
        timer.schedule(deadline: .now(), repeating: .milliseconds(1000));
        timer.setEventHandler {
            timeout -= 1
            if timeout < 0 {
                timer.cancel()
                DispatchQueue.main.async {
                    finshBlock()
                }
                return;
            }
            DispatchQueue.main.async {
                runBlock(timeout)
            }
        }
        timer.resume()
        return timer
    }
    
    @discardableResult
    func startCountDown(_ timeOut: Int, runBlock: @escaping (Int) -> Void, finshBlock: @escaping () -> Void)  -> DispatchSourceTimer {
        return UIView.startCountDown(timeOut, runBlock: runBlock, finshBlock: finshBlock);
    }
    
    func addSubViews(_ views: Array<UIView>) {
        for v in views {
            self.addSubview(v)
        }
    }
    
    func addGradient(bounds: CGRect, colors: [UIColor], locations: [NSNumber] = [0, 1], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        var cgColors: [CGColor] = []
        colors.forEach { color in
            cgColors.append(color.cgColor)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = cgColors
        gradientLayer.locations = locations
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradient(colors: [UIColor]) {
        self.addGradient(bounds: self.bounds, colors: colors)
    }
}
