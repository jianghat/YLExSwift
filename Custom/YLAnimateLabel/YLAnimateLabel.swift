//
//  YLAnimateUILabel.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/6.
//

import UIKit

class YLAnimateLabel: UILabel {
    // 开始的数字
    private var fromNum: Double = 0
    
    // 结束的数字
    private var toNum: Double = 0
    
    // 动画的持续时间
    private var duration: TimeInterval = 1.0
    
    // 动画开始时刻的时间
    private var startTime: CFTimeInterval = 0
    
    // 定时器
    private var displayLink: CADisplayLink?
    
    // 格式化字符串闭包
    var formatBlock: ((_ value: Double) -> NSString)?
    
    deinit {
        stopCounting()
    }
    
    // 从数字fromNum经过duration长的时间变化到数字toNum
    func countFrom(fromNum: Double, toNum: Double, duration: Double) {
        self.text = "\(fromNum)"
        self.fromNum = fromNum
        self.toNum = toNum
        self.duration = duration
        startDisplayLink()
    }
    
    // 开始定时器
    private func startDisplayLink() {
        if (displayLink != nil) {
            displayLink!.invalidate()
        }
        displayLink = CADisplayLink(target: self, selector: .handleDisplayLink)
        // 记录动画开始时刻的时间
        startTime = CACurrentMediaTime()
        displayLink?.add(to: .current, forMode: .common)
    }
    
    // 结束定时器
    private func stopCounting() {
        displayLink?.invalidate()
    }
    
    // 定时器的回调
    @objc fileprivate func handleDisplayLink(displayLink: CADisplayLink) {
        if displayLink.timestamp - startTime >= duration {
            if (formatBlock != nil) {
                self.text = formatBlock!(toNum) as String
            } else {
                self.text = FuncUtils.formatNumber(NSNumber(value: toNum))
            }
            // 结束定时器
            stopCounting()
        } else {
            // 计算现在时刻的数字
            let current = (toNum - fromNum) * (displayLink.timestamp - startTime) / duration + fromNum
            if (formatBlock != nil) {
                self.text = formatBlock!(current) as String
            } else {
                self.text = FuncUtils.formatNumber(NSNumber(value: current))
            }
        }
    }
}

private extension Selector {
    static let handleDisplayLink = #selector(YLAnimateLabel.handleDisplayLink)
}
