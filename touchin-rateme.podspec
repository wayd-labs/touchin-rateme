Pod::Spec.new do |s|
  s.name             = "touchin-rateme"
  s.summary = "RateMe please table cells, alers and screens"
  s.homepage = "https://github.com/wayd-labs/touchin-rateme.git"
  s.version          = "0.6.2"
  s.license          = 'MIT'
  s.author           = { "alarin" => "me@alarin.ru" }
  s.source           = { :git => "https://github.com/wayd-labs/touchin-rateme.git", :tag => s.version.to_s }

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
