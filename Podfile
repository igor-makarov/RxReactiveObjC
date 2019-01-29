#!/usr/bin/env ruby

install! 'cocoapods', deterministic_uuids: false
use_frameworks!
inhibit_all_warnings!

workspace 'RxReactiveObjC'
project 'RxReactiveObjC.xcodeproj'

abstract_target 'Common' do
  pod 'RxSwift'
  pod 'ReactiveObjC'
  pod 'RxReactiveObjC', path: './', testspecs: ['Tests'], inhibit_warnings: false
  abstract_target 'iOS' do
    platform :ios, '9.0'
    pod 'SwiftLint'
    target 'RxReactiveObjCTests'
  end
end
