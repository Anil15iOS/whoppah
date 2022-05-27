# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
source 'https://github.com/CocoaPods/Specs.git'

workspace 'Whoppah.xcworkspace'
project 'Whoppah.xcodeproj'
project 'Whoppah/WhoppahCore/WhoppahCore.xcodeproj'

# ignore all warnings from all dependencies
inhibit_all_warnings!
use_frameworks!

def shared_pods
  pod 'RxSwift', '~> 5.1'
  pod 'RxCocoa', '~> 5.1'
end

def common_pods
  
  # Authentication
  pod 'GoogleSignIn', '~> 5.0'
  pod 'GooglePlaces', '~> 3.8'
  
  # UI
  pod 'ExpandableCell', '~> 1.3'
  pod 'MessengerKit', :git => 'https://github.com/steve228uk/MessengerKit.git', :tag => '1.0.5'
  pod 'SquareMosaicLayout', '~> 4.1'
  pod 'KafkaRefresh', '~> 1.4'
  pod 'Lightbox', '~> 2.3'
  pod 'OpalImagePicker', '~> 2.1'
  pod 'FlagPhoneNumber', '~> 0.8'
  pod 'EasyTipView', '~> 2.0'
  pod 'RxAnimated', '~> 0.7'
  pod 'UICollectionViewLeftAlignedLayout', '~> 1.0'
  pod 'HGCircularSlider', '~> 2.2.0'
  pod 'MaterialComponents/Buttons'
  pod 'ActiveLabel'
  pod 'TLPhotoPicker'
  
  # Caching
  pod 'Cache', '~> 5.2'
  
  # Linting, tools & misc
  pod 'R.swift', '~> 5.1'
  shared_pods
end

target 'Whoppah' do
  project 'Whoppah.xcodeproj'
  common_pods
end

target 'Whoppah-testing' do
  project 'Whoppah.xcodeproj'
  common_pods
end

target 'WhoppahTests' do
  project 'Whoppah.xcodeproj'
  common_pods
end

target 'WhoppahCore' do
  project 'Whoppah/WhoppahCore/WhoppahCore.xcodeproj'
  shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
            config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
        end
    end
end
