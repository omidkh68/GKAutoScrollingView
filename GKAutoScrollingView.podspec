#
# Be sure to run `pod lib lint GKAutoScrollingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GKAutoScrollingView'
  s.version          = '0.1.1'
  s.summary          = 'A customizable, easy to use infinite scroll view similar to the App Store banner.'

  s.description      = 'A customizable, easy to use infinite scroll view similar to the App Store banner. GKAutoScrollingView offers numerous protocols and properties for customization.'

  s.homepage         = 'https://github.com/gkye/GKAutoScrollingView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '=' => 'George Kye' }
  s.source           = { :git => 'https://github.com/gkye/GKAutoScrollingView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/kyegeorge'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/**/*'
  s.frameworks = 'UIKit'
end
