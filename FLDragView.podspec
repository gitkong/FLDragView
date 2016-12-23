

Pod::Spec.new do |s|

  s.name         = "FLDragView"
  s.version      = "1.0.0"
  s.summary      = "你使用过最简单最好用拖拽的view"

  s.homepage     = "https://github.com/gitkong/FLDragView"

  s.license      = "MIT"

  s.author             = { "gitkong" => "13751855378@163.com" }

  s.source       = { :git => "https://github.com/gitkong/FLDragView", :tag => "#{s.version}" }

  s.source_files  = "UIView+drag/*.{h,m}”


end
