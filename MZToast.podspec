Pod::Spec.new do |spec|
  spec.name         = "MZToast"
  spec.version      = "0.0.1"
  spec.summary      = "Swift toast and loading"
  spec.homepage     = "https://github.com/1691665955/MZToast"
  spec.authors         = { 'MZ' => '1691665955@qq.com' }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.source = { :git => "https://github.com/1691665955/MZToast.git", :tag => spec.version}
  spec.platform     = :ios, "9.0"
  spec.swift_version = '5.0'
  spec.source_files  = "MZToast/MZToast/*"
end
