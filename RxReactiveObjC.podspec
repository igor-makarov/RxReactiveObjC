#!/usr/bin/env ruby
filename = File.basename(__FILE__, '.podspec')
def self.infer_version_from_git
  return nil unless Dir.exist?('.git')

  `git tag --merged HEAD --sort=committerdate`.split.select do |tag|
    Version.correct?(tag)
  end.last
end

Pod::Spec.new do |s|
  s.name         = filename
  s.version      = infer_version_from_git || (raise Informative, 'Could not infer version from git')
  s.summary      = 'Bridge between RxSwift and ReactiveObjC'

  s.description  = <<-DESC
                    This is a small library that I really had to make. It provides two-way bridging 
                    between RxSwift and ReactiveObjC. The reason it's in a separate repo is because
                    I really wanted to run tests on it.
  DESC
  s.homepage     = 'https://github.com/igor-makarov/RxReactiveObjC'
  s.license      = 'MIT'
  s.author       = { 'Igor Makarov' => 'igormaka@gmail.com' }
  s.source       = { git: 'https://github.com/igor-makarov/RxReactiveObjC.git',
                     tag: s.version.to_s }

  s.platform = :ios, :osx, :watchos
  s.swift_versions = %w[5.0 5.1]
  s.ios.deployment_target = '9.0'
  s.watchos.deployment_target = '3.0'
  s.osx.deployment_target = '10.10'

  s.subspec 'Core' do |sp|
    sp.source_files = 'Sources/Core/**/*.swift'
  end

  s.subspec 'MapKit' do |sp|
    sp.platform = :ios
    sp.source_files = 'Sources/MapKit/**/*.swift'
    sp.dependency 'RxReactiveObjC/Core'
    sp.dependency 'RxMKMapView'
  end

  s.subspec 'DataSource' do |sp|
    sp.platform = :ios
    sp.source_files = 'Sources/DataSource/**/*.swift'
    sp.dependency 'RxReactiveObjC/Core'
    sp.dependency 'RxDataSources'
  end

  s.test_spec 'CoreTests' do |sp|
    sp.platform = :ios, :osx
    sp.ios.deployment_target = '9.0'
    sp.osx.deployment_target = '10.10'

    sp.dependency 'RxReactiveObjC/Core'
    sp.source_files = 'Tests/**/*.swift'
  end

  s.dependency 'RxSwift', '~> 6'
  s.dependency 'ReactiveObjC', '>=3.1.0'
end
