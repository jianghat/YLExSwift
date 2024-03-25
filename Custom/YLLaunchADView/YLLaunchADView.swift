//
//  YLLaunchADView.swift
//  gamefi-ios
//
//  Created by ym on 2024/1/16.
//

import UIKit
import YYKit

class YLLaunchADView: UIView {
    var webURL: String?
    var countTimer: YYTimer?
    var count: NSInteger?
//    {
//       didSet {
//           RunLoop.main.add(countTimer!, forMode: RunLoop.Mode.common)
//       }
//   }
    var touchBlock: ((String?) -> ())?
    
    static func show(touchBlock: @escaping ((String?) -> ())) {
        if let model = LaunchADModel.getLocalModel() {
            let view = YLLaunchADView(frame: .zero)
            view.touchBlock = touchBlock
            view.countTimer = YYTimer(timeInterval: 1, target: view, selector: #selector(countDown), repeats: true)
            
            if let localPath = model.localPath {
                do {
                    let data = try Data(contentsOf: localPath)
                    view.adImgView.image = UIImage(data: data)
                    view.countBtn.setTitle("跳过\(model.showTime)", for: .normal)
                    view.webURL = model.webURL
                    view.count = model.showTime
                    let window = UIApplication.shared.windows.first
                    window?.addSubview(view)
                } catch {
                    downloadImage(model: model)
                }
            } else {
                downloadImage(model: model)
            }
        }
    }
    
    static func setValue(imgURL: String!, webURL: String, showTime: NSInteger) {
        if let model = LaunchADModel.getLocalModel() {
            if model.imgURL == imgURL && model.localPath != nil {
                return
            }
        }
        let model = LaunchADModel()
        model.imgURL = imgURL
        model.webURL = webURL
        model.showTime = showTime
        downloadImage(model: model)
    }
    
    @objc func countDown() {
        guard var count = self.count else { return }
        count -= 1
        self.count = count
        countBtn.setTitle("跳过\(count)", for: .normal)
        if count == 0 {
            dismissAction()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: YLScreenWidth, height: YLScreenHeight))
        self.backgroundColor = UIColor.white
        
        adImgView.frame = self.bounds
        adImgView.isUserInteractionEnabled = true
        adImgView.contentMode = .scaleAspectFill
        adImgView.clipsToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        adImgView.addGestureRecognizer(tap)
        self.addSubview(adImgView)
        
        let btnW: CGFloat = 60
        let btnH: CGFloat = 30
        countBtn.frame = CGRect(x: YLScreenWidth - btnW - 24, y: btnH, width: btnW, height: btnH)
        countBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        countBtn.setTitleColor(.white, for: .normal)
        countBtn.backgroundColor = UIColor.init(white: 0.2, alpha: 0.6)
        countBtn.layer.cornerRadius = 4
        countBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        self.addSubview(countBtn)
    }
    
    @objc func tapAction() {
        if let block = touchBlock {
            block(webURL)
            dismissAction()
        }
    }
    
    @objc func dismissAction() {
        countTimer!.invalidate()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func deleteOldImg(localPath: URL?) {
        if let path = localPath {
            do {
                try FileManager.default.removeItem(at: path)
            }catch {
                print(error)
            }
        }
    }
    
    static func downloadImage(model: LaunchADModel) {
        DispatchQueue.global().async {
            do {
                guard let url = URL(string: model.imgURL) else { return }
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    do {
                        guard let localPath = model.localPath else { return }
                        try image.pngData()?.write(to: localPath)
                        model.save()
                    } catch { }
                }
            } catch { }
        }
    }
    
    lazy var adImgView: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    
    lazy var countBtn: UIButton = {
        let button = UIButton()
        return button
    }()
}

class LaunchADModel: NSObject {
    var imgURL: String!
    var webURL: String?
    var showTime = 3
    var localPath: URL? {
        get {
            if let url = URL(string: imgURL) {
                let imgName = url.lastPathComponent
                return LaunchADModel.filePath(imgName: imgName)
            }
            return nil
        }
    }
    
    static func getLocalModel() -> LaunchADModel? {
        if let dic = UserDefaults.standard.value(forKey: "LaunchADModel") as? [String : String] {
            let model = LaunchADModel()
            model.imgURL = dic["imgURL"]
            model.webURL = dic["webURL"]
            guard let timeString = dic["showTime"], let showTime = NSInteger(timeString) else {
                return nil
            }
            model.showTime = showTime
            return model
        }
        return nil
    }
    
    func save() {
        let dic = ["imgURL" : imgURL, "webURL" : webURL!, "showTime" : "\(showTime)"] as [String : String]
        UserDefaults.standard.set(dic, forKey: "LaunchADModel")
    }
    
    static func filePath(imgName: String) -> URL {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: cachesPath).appendingPathComponent(imgName)
    }
    
    func deleteOldImage() {
        if let localPath = self.localPath {
            do {
                try FileManager.default.removeItem(at: localPath)
            } catch {
                
            }
        }
    }
}
