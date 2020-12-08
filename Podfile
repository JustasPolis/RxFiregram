# Uncomment the next line to define a global platform for your project
project 'RxFiregram', 'Testing' => :debug
# platform :ios, '12.0'
plugin 'cocoapods-binary'

target 'RxFiregram' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
 
  pod 'Then', :binary => true
  pod 'SDWebImage', :binary => true
  pod 'RxSwift'
  pod 'RxCocoa'
  pod "RxDataSources", :binary => true
  pod "Resolver", :binary => true
  pod 'RxSwiftExt', :binary => true
  pod 'CodableFirebase', :binary => true
  pod 'RxFirebase/Database'
  pod 'RxFirebase/Storage'
  pod 'RxFirebase/Auth'
  pod 'Firebase/Auth'          
  pod 'Firebase/Database'    
  pod 'Firebase/Storage'
  
 
  target 'RxFiregramTests' do
     inherit! :search_paths
    pod 'RxTest'
    pod 'RxBlocking'
  end

  target 'RxFiregramUITests' do
    # Pods for testing
    pod 'RxTest'
    pod 'RxBlocking'
  end
end

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
             bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
           end
       end
   end
end
