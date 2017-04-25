source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target "hahaxueche" do
    pod 'SVProgressHUD'
    pod 'SDWebImage', '~> 3.8'
    pod 'libPhoneNumber-iOS', '~> 0.9.1'
    pod 'DateTools'
    pod "Appirater"
    pod 'AFNetworking', '~> 3.1'
    pod 'SAMKeychain', '~> 1.5.2'
    pod 'MJRefresh', '~> 3.1.1'
    pod 'Masonry', '~> 1.0.2'
    pod 'Mantle', '~> 2.1.0'
    pod 'CRToast'
    pod 'KLCPopup'
    pod 'pop', '~> 1.0'
    pod 'StepSlider', '~> 0.1.5'
    pod 'BEMCheckBox'
    pod 'INTULocationManager', '~> 4.2'
    pod 'AMapFoundation', '~> 1.3.4'
    pod 'SDCycleScrollView','~> 1.6'
    pod 'HCSStarRatingView', '~> 1.4'
    pod 'ActionSheetPicker-3.0'
    pod "Pingpp/Alipay", '~> 2.2.10'
    pod "Pingpp/Fqlpay", '~> 2.2.10'
    pod "Pingpp/CmbWallet", '~> 2.2.10'
    pod "Pingpp/Wx", '~> 2.2.10'
    pod 'MMNumberKeyboard'
    pod 'RSKImageCropper'
    pod 'Harpy'
    pod 'UMengAnalytics-NO-IDFA', '~> 4.1.4'
    pod 'TTTAttributedLabel', '~> 2.0'
    pod 'QIYU_iOS_SDK', '~> 3.4'
    pod 'HMSegmentedControl', '~> 1.5'
    pod 'SwipeView', '~> 1.3'
    pod 'UITextView+Placeholder', '~> 1.2'
    pod 'DZNEmptyDataSet'
    pod 'APAddressBook'
    pod 'DXCustomCallout-ObjC', '~> 0.2'
    pod 'iCarousel', '~> 1.8'

end



# Update the project / pod segttings after pod install. Keep in mind please don't run Pod install when Xcode is open.
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
