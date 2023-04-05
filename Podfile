# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Bot365' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Bot365
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'ScreenType'
  pod 'KeychainSwift', '~> 19.0'
  pod 'ActiveLabel'
  pod 'SwiftyUserDefaults'
  pod 'IronSourceSDK','7.2.6.0'
  pod 'NVActivityIndicatorView'
  pod 'FSCalendar'
  pod 'AnchoredBottomSheet', '~> 1.6.2'
  pod 'SwiftLint'
  
 
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
