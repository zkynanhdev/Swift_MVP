platform :ios, '10.0'
inhibit_all_warnings!

target 'UserApp' do
  pod 'Alamofire'
  pod 'ImageLoader', '~> 0.15'

  target 'UserAppTests' do
    inherit! :search_paths
    pod 'OCMock', '~> 2.0.1'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
  end
end
