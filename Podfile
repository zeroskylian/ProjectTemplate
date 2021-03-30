platform :ios, '11.0'
inhibit_all_warnings!
use_modular_headers!

target 'ProjectTemplate' do
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'Alamofire'
  pod 'Moya'
  pod 'GRDB.swift'
  pod 'Toast-Swift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
