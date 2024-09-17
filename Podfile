# Uncomment the next line to define a global platform for your project
platform :ios, '15.4'

target 'F1App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for F1App

  pod 'SwiftyJSON'
  pod 'lottie-ios'
  pod 'FirebaseCore'
  pod 'FirebaseFirestore'
  pod 'FirebaseAuth'
  pod 'GoogleSignIn'
  pod 'FirebaseStorage'
  pod 'Firebase/Analytics'
 

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end