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
  target 'RxReactiveObjCTests' do
    platform :ios, '9.0'
    pod 'SwiftLint'
  end
end
