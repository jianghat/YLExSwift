Pod::Spec.new do |s|
  s.name         = "YLExSwift"
  s.version      = "0.0.1"
  s.summary      = "YLDragView."
  s.description  = <<-DESC
                    swift常用方法及组件
                   DESC

  s.homepage     = "https://github.com/jianghat/YLExSwift"
  s.license      = { :type => 'MIT', :file => 'LICENSE'
  s.author       = { "jiang" => "549488710@qq.com" }
  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/jianghat/YLDragView.git", :tag => "#{s.version}" }
  s.source_files  = 'Custom/**/*.swift', 'Foundation/**/*.swift', 'Marco/*.swift', 'UIKit/**/*.swift'
  s.framework  = 'UIKit', 'Foundation'
  s.requires_arc = true

end
