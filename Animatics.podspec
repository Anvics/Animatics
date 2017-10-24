#
# Be sure to run `pod lib lint Animatics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Animatics'
  s.version          = '1.0.3'
  s.summary          = 'Declarative animations'

  s.description      = <<-DESC
    Animatics make it easy to create, chain, reuse and perform animations.
                       DESC

  s.homepage         = 'https://github.com/Anvics/Animatics.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nikita Arkhipov' => 'nikitarkhipov@gmail.com' }
  s.source           = { :git => 'https://github.com/Anvics/Animatics.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Animatics/Classes/**/*'
  
  s.frameworks = 'UIKit'
end
