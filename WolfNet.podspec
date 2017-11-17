Pod::Spec.new do |s|

  s.name         = "WolfNet"
  s.version      = "1.0.4"
  s.summary      = "泛型的网络请求与解析"
  s.homepage     = "https://github.com/xiaozao2008/WolfNet"
  s.license      = "MIT"
  s.ios.deployment_target = '9.0'
  s.author             = { "xiaozao2008" => "xiaozao2008@msn.cn" }
  s.source       = { :git => "https://github.com/xiaozao2008/WolfNet.git", :tag => "#{s.version}" }
  s.source_files  = "WolfNet/Wolf/*.{h,m,swift}"

  s.dependency "Moya"
  s.dependency "ObjectMapper"

end
