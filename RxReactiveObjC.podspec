#!/usr/bin/env ruby
filename = File.basename(__FILE__, '.podspec')

Pod::Spec.new do |s|
  s.name         = filename
  s.version      = '1.0.0'
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

  s.subspec 'Core' do |sp|
    sp.platform = :ios, :osx, :watchos
    sp.ios.deployment_target = '9.0'
    sp.watchos.deployment_target = '2.0'
    sp.osx.deployment_target = '10.10'

    sp.source_files = 'Sources/Core/**/*.swift'
  end

  s.subspec 'DataSource' do |sp|
    sp.platform = :ios, '9.0'

    sp.source_files = 'Sources/DataSource/**/*.swift'

    sp.dependency 'RxDataSources'
  end

  s.test_spec 'CoreTests' do |sp|
    sp.dependency 'RxReactiveObjC/Core'
    sp.source_files = 'Tests/**/*.swift'
  end

  s.dependency 'RxSwift', '>=4.0.0'
  s.dependency 'ReactiveObjC', '>=3.1.0'
end
