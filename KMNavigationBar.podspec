#
# Be sure to run `pod lib lint KMNavigationBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KMNavigationBar'
  s.version          = '0.0.1'
  s.summary          = '控制器切换时，让导航栏平滑过渡（颜色、图片、透明度）'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    控制器切换时，让导航栏平滑过渡。
    可为每个控制器设置单独的导航栏背景色、背景图片、透明度
                       DESC

  s.homepage         = 'https://github.com/hkm5558/KMNavigationBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'km' => 'szhuangkm@163.com' }
  s.source           = { :git => 'https://github.com/hkm5558/KMNavigationBar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version    = '4.2'
  s.ios.deployment_target = '9.0'

  s.source_files = 'KMNavigationBar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KMNavigationBar' => ['KMNavigationBar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
