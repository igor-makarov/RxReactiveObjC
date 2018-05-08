#!/usr/bin/env ruby

install! 'cocoapods',
         :deterministic_uuids => false
use_frameworks!

workspace 'RxReactiveObjC'
project 'RxReactiveObjC.xcodeproj'

abstract_target 'Common' do
  pod 'RxSwift', :inhibit_warnings => true
  pod 'ReactiveObjC', :inhibit_warnings => true
  pod 'RxReactiveObjC', :path => './', :testspecs => ['Tests']
  abstract_target 'iOS' do
    platform :ios, '9.0'
    pod 'SwiftLint'
    target 'RxReactiveObjCTests'
  end
end

post_install do |installer_representation|
  pods_project = installer_representation.pods_project

  if ENV['SWIFT_VERSION']
    SWIFT_VERSION = "#{ENV['SWIFT_VERSION']}.0"
  else 
    SWIFT_VERSION = File.open(".swift-version", "rb").read
  end

  pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = SWIFT_VERSION
    end
  end
end
