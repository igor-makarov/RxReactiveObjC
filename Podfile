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