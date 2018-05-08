#!/usr/bin/env ruby
filename = File.basename(__FILE__, '.podspec')

Pod::Spec.new do |s|

  s.name         = "#{filename}"
  s.version      = '1.0.0'
  s.summary      = 'Bridge between RxSwift and ReactiveObjC'

  s.description  = <<~DESC
                    This is a small library that I really had to make. It provides two-way bridging 
                    between RxSwift and ReactiveObjC. The reason it's in a separate repo is because
                    I really wanted to run tests on it.
                    DESC
  s.homepage     = 'https://github.com/igor-makarov/RxReactiveObjC'
  s.license      = 'MIT'
  s.author       = { 'Igor Makarov' => 'igormaka@gmail.com' }
  s.source       = { :git => 'https://github.com/igor-makarov/RxReactiveObjC.git', 
                     :tag => "#{s.version}" }

  # todo remove:
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'
  s.source_files = 'Sources/RxReactiveObjC/**/*.swift'
  s.dependency 'RxSwift', '>=4.0.0'
  s.dependency 'ReactiveObjC', '>=3.1.0'
  s.test_spec 'Tests' do |sp|
      sp.dependency 'RxSwift', '>=4.0.0'
      sp.dependency 'ReactiveObjC', '>=3.1.0'
      sp.source_files = 'Tests/RxReactiveObjCTests/**/*.swift'
  end
end
