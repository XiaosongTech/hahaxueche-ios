source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'SVProgressHUD'
pod 'SDWebImage', '~> 3.7'
pod 'libPhoneNumber-iOS', '~> 0.8'
pod 'DateTools'
pod "Appirater"
pod 'Fabric'
pod 'Crashlytics'
pod 'Instabug'
pod 'UMengAnalytics-NO-IDFA'
pod 'AFNetworking', '~> 2.6.1'
pod 'SSKeychain'
pod 'MJRefresh'
pod 'Masonry'
pod 'Mantle'
pod 'CRToast'
pod 'KLCPopup'
pod 'pop', '~> 1.0'
pod 'StepSlider'
pod 'BEMCheckBox'
pod 'INTULocationManager'
pod 'AMap2DMap'
pod 'SDCycleScrollView','~> 1.6'

# Update the project / pod settings after pod install. Keep in mind please don't run Pod install when Xcode is open.
post_install do |installer_representation|
    projectSDK = nil
    
    puts"\n\nUpdating Pod targets to set Build for Active Arch == NO automatically"
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            if projectSDK.nil?
                projectSDK = config.build_settings['SDKROOT']
            end
        end
    end
    puts "Updating ONLY_ACTIVE_ARCH for the project incase project settings were mismatched. (The project settings *shouldn't* cause a problem, but they definitely do."
    puts "Updating the base SDK of the project to match that of the targets. This prevents the default No SDK (Latest OS X)"
    installer_representation.pods_project.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['SDKROOT'] = projectSDK
    end
end