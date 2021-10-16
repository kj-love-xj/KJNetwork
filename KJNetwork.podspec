#
# Be sure to run `pod lib lint KJNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KJNetwork'
  s.version          = '0.0.18'
  s.summary          = 'KJNetwork'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 基于AFN的网络请求
                       DESC

  s.homepage         = 'https://github.com/kj-huang/KJNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jin' => 'kegem@foxmail.com' }
  s.source           = { :git => 'https://github.com/kj-huang/KJNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KJNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KJNetwork' => ['KJNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'MJExtension'
end
