#!/usr/bin/env ruby

install! 'cocoapods', deterministic_uuids: false
use_frameworks!
inhibit_all_warnings!

workspace 'RxReactiveObjC'
project 'RxReactiveObjC.xcodeproj'

abstract_target 'Common' do
  pod 'RxSwift'
  pod 'ReactiveObjC'
  pod 'RxReactiveObjC', path: './', testspecs: ['CoreTests'], inhibit_warnings: false
  target 'RxReactiveObjCSample' do
    platform :ios, '13.0'
    pod 'SwiftLint'
  end
end

post_install do |installer_representation|
  pods_projects = installer_representation.generated_projects

  pods_projects.each do |project|
    project.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_i < 12
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
      
      project.targets.each do |target|
        target.build_configurations.each do |config|
          if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_i < 12
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
          end

          # else Xcode 12 complains
          config.build_settings.delete('ARCHS')
        end
      end
    end
    project.root_object.attributes['LastUpgradeCheck'] = '1200'
  end
end
