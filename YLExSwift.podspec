Pod::Spec.new do |s|
  s.name         = "YLExSwift"
  s.version      = "0.0.1"
  s.summary      = "YLDragView."
  s.description  = <<-DESC
                    swift常用方法及组件
                   DESC

  s.homepage     = "https://github.com/jianghat/YLExSwift"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "jiang" => "549488710@qq.com" }
  s.source       = { :git => "https://github.com/jianghat/YLDragView.git", :tag => "#{s.version}" }
  s.source_files  = 'Custom/**/*.swift', 'Foundation/**/*.swift', 'Marco/*.swift', 'UIKit/**/*.swift'
  s.framework  = 'UIKit', 'Foundation', 'AVFoundation'
  s.requires_arc = true
  s.ios.deployment_target = '13.0'
  
  s.dependency 'HandyJSON'
  s.dependency 'MJRefresh'
  s.dependency 'RxSwift'
  s.dependency 'SwiftDate'
  s.dependency 'YYKit'
  
  s.swift_version = '5.0'
end
