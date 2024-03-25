//
//  UITextField+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/11/2.
//

import UIKit
import RxSwift

extension UITextField {
    private struct PlaceholderColorKey {
        static var identifier: String = "PlaceholderColorKey"
    }
    
    var placeholderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &PlaceholderColorKey.identifier) as! UIColor
        }
        set(newColor) {
            objc_setAssociatedObject(self, &PlaceholderColorKey.identifier, newColor, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let attrString = NSMutableAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: newColor])
            self.attributedPlaceholder = attrString
        }
    }
    
    func currentOffset() -> NSInteger {
        return self.offset(from: self.beginningOfDocument, to: self.selectedTextRange!.start);
    }
    
    func makeOffset(_ offset: NSInteger) {
        var currentOffset: NSInteger  = self.offset(from: self.endOfDocument, to: self.selectedTextRange!.end);
        currentOffset += offset;
        
        let newPos: UITextPosition = self.position(from: self.endOfDocument, offset: currentOffset)!;
        self.selectedTextRange = self.textRange(from: newPos, to: newPos);
    }
    
    func makeOffsetFromBeginning(_ offset: NSInteger) {
        // 先把光标移动到文首，然后再调用上面实现的偏移函数。
        let begin: UITextPosition = self.beginningOfDocument;
        let start: UITextPosition = self.position(from: begin, offset: 0)!;
        let range:UITextRange = self.textRange(from: start, to: start)!;
        self.selectedTextRange = range;
        self.makeOffset(offset);
    }
    
    func marginLeft(_ width: CGFloat) {
        if width <= 0  {
            return
        }
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        self.leftViewMode = .always
    }
    
    func marginRight(_ width: CGFloat) {
        if width <= 0  {
            return;
        }
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        self.rightViewMode = .always
    }
    
    func setMaxLength(maxLength: Int, disposeBag: DisposeBag) {
        self.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let selectedRange = self.markedTextRange
                if selectedRange == nil {
                    let text = self.text ?? ""
                    if text.count > maxLength {
                        let index = text.index(text.startIndex, offsetBy: maxLength)
                        self.text = String(text[..<index])
                    }
                }
            }).disposed(by: disposeBag)
    }
}
