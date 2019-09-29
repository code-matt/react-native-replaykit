require "json"

package = JSON.parse(File.read(File.join(__dir__, "./package.json")))

Pod::Spec.new do |s|
  s.name         = "RNReactNativeReplaykit"
  s.version      = package["version"]
  s.summary      = "RNReactNativeReplaykit"
  s.description  =  package["description"]
  s.homepage     = "https://github.com/code-matt/react-native-replaykit"
  s.license      = "MIT"
  s.license      = { :type => "MIT" }
  s.author             = { "author" => "https://github.com/code-matt" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "git@github.com:code-matt/react-native-replaykit.git", :tag => "record_inapp_audio_merge" }
  s.source_files = "ios/*.{h,m,swift}"
  s.requires_arc = true
  s.swift_version = '5.0'
  s.dependency "React"
end