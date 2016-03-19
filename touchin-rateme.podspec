Pod::Spec.new do |s|
  s.name             = "touchin-rateme"
  s.version          = "0.6.1"
  s.license          = 'MIT'
  s.author           = { "alarin" => "me@alarin.ru" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/touchin-analytics.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.public_header_files = 'Pod/Classes/*.h'
  s.source_files = 'Pod/Classes'
#  s.resources = 'Pod/Assets'
  s.resource_bundles = {
    'TIRateMe' => ['Pod/Assets/TIRateMeCell.xib', 'Pod/Assets/*.lproj']
  }

  s.frameworks = 'UIKit'
  s.dependency 'touchin-trivia'
  s.dependency 'touchin-analytics/CoreIOS'
end
