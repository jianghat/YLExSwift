//
//  UIImage+YLAdd.swift
//  Driver
//
//  Created by ym on 2020/9/25.
//  Copyright © 2020 edonesoft. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    //    根据图片名称在bundle中搜索该图片
    class func imageFromBundle(_ name:String) -> UIImage! {
        let path = Bundle.main.path(forResource: name, ofType: nil);
        if path != nil {
            return UIImage(contentsOfFile: path!)!;
        } else {
            return UIImage(named: name)!
        }
    }
    
    // 根据color生成图片
    class func imageWithColor(_ color:UIColor) -> UIImage! {
        return self.imageWithColor(color, size: CGSize(width: 1, height: 1))
    }
    
    class func imageWithColor(_ color:UIColor, size: CGSize) -> UIImage! {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorImage!
    }
    
    //        view快照
    class func imageWithView(_ view: UIView) -> UIImage {
        let size: CGSize  = view.bounds.size
        //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //  改变图片的color
    func imageWithTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //  图片圆角
    func roundImage(size:CGFloat, radius:CGFloat) -> UIImage {
        return self.roundImage(size: size, radius: radius, borderWidth:0, borderColor: .clear)
    }
    
    func roundImage(size:CGFloat, radius:CGFloat, borderWidth:CGFloat?, borderColor:UIColor?) -> UIImage {
        let scale = self.size.width / size
        var width: CGFloat =  0
        var color: UIColor = .clear
        
        if let borderWidth = borderWidth {
            width = borderWidth * scale
        }
        
        if let borderColor = borderColor {
            color = borderColor
        }
        
        let radius = radius * scale
        let react = CGRect(x: width, y: width, width: self.size.width - 2 * width, height: self.size.height - 2 * width)
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        color.setStroke()
        let path = UIBezierPath(roundedRect:react, cornerRadius: radius)
        //绘制边框
        path.lineWidth = width
        path.stroke()
        path.addClip()
        //画图片
        draw(in: react)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func circleImage(size: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) -> UIImage? {
        let imageSize = CGSize(width: size, height: size)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: imageSize))
        path.addClip()
        draw(in: CGRect(origin: CGPoint(x: borderWidth/2.0, y: borderWidth/2.0), size: imageSize))
        //绘制边框
        borderColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizableImage(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIImage {
        return self.resizableImage(withCapInsets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right), resizingMode: .stretch)
    }
    
    //  重设图片大小
    func resizeImage(_ reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func cropImage(_ rect: CGRect) -> UIImage? {
        guard let sourceImage = self.cgImage else { return nil }
        //计算原点(startPoint)的偏移量
        let point = CGPoint(x: rect.origin.x * scale, y: rect.origin.y * scale)
        // 计算size
        let size = CGSize(width: rect.width * scale, height: rect.height * scale)
        let rect = CGRect(origin: point, size: size)
        guard let image = sourceImage.cropping(to: rect) else { return nil }
        return UIImage(cgImage: image)
    }
    
    func scaleToFitAtCenter(_ size: CGSize) -> UIImage? {
        let scaleW_H = size.width / size.height
        let selfScaleW_H = size.width / size.height
        
        if selfScaleW_H > scaleW_H {
            let w = size.height * scaleW_H
            let h = size.height
            let x = (size.width - w) / 2.0
            let y: CGFloat = 0
            return cropImage(CGRect(x: x, y: y, width: w, height: h))?.resizeImage(size)
        } else {
            let w = self.size.width
            let h = self.size.width / scaleW_H
            let x: CGFloat = 0
            let y = (self.size.height - h) / 2.0
            return cropImage(CGRect(x: x, y: y, width: w, height: h))?.resizeImage(size)
        }
    }
    
    func scaleImage(_ targetSize: CGSize) -> UIImage {
        let width = self.size.width
        let height = self.size.height
        
        let widthFactor = targetSize.width / width
        let heightFactor = targetSize.height / height
        let scale = (widthFactor < heightFactor) ? widthFactor : heightFactor
        
        let reSize = CGSize(width: width * scale, height: height * scale)
        return resizeImage(reSize)
    }
    
    //  添加高斯模糊滤镜
    func blur(_ radio: CGFloat) -> UIImage! {
        let inputImage = CIImage(image: self)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur" )!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(radio, forKey: kCIInputRadiusKey)
        
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: .zero, size: self.size)
        
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        //显示生成的模糊图片
        let newImage = UIImage(cgImage: cgImage!)
        return newImage
    }
    
    //图片压缩到几兆之内
    func compressionToSize(_ size: CGFloat) -> Data {
        var imageData:Data = self.jpegData(compressionQuality: 1)!
        var rate:CGFloat = 1
        while(CGFloat(imageData.count) > size * 1000) {
            rate -= 0.1
            imageData = self.jpegData(compressionQuality: rate)!
            if(rate<=0.19) {
                break
            }
        }
        return imageData
    }
    
    /**
     *  识别图片二维码
     *  @returns: 二维码内容
     */
    func recognizeQRCode() -> String? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: self.cgImage!))
        guard (features?.count)! > 0 else { return nil }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString
    }
}
