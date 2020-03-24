
Pod::Spec.new do |s|
  s.name          = "ZYNavigationBar"
  s.version       = "1.0.4"
  s.summary       = "A Custom UINavigationBar."
  s.homepage      = "https://github.com/zhouyudk/ZYNavigationBar/"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "yu zhou" => "384986004@qq.com" }
  s.source        = { :git => "https://github.com/zhouyudk/ZYNavigationBar.git", :tag => s.version }
  s.source_files  = "Source/*.swift"
  s.ios.deployment_target = "9.0"
end
