#
# Be sure to run `pod lib lint QAView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QAView"
  s.version          = "0.1.0"
  s.summary          = "QAView visualizes dependencies in between elemets of 2 arrays."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "QAView represents 2 UIScrollViews: questionsScroller & answersScroller populated with 2 arrays: questions & answers respectively. When question is tapped, it becomes active and ready to be connected to answers. Use this pod whenever you have to visualize dependencies in between elements of 2 arrays."

  s.homepage         = "https://github.com/belakva/QAView"
  s.screenshots      = "http://i.imgur.com/qE6fPfI.png"
  s.license          = 'MIT'
  s.author           = { "belakva" => "kerd@bk.ru" }
  s.source           = { :git => "https://github.com/belakva/QAView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nikita_kerd'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'QAView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
