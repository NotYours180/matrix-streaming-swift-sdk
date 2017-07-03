use_frameworks!

def shared_pods
    pod 'MatrixAuthSDK', :git => 'https://github.com/matrix-io/matrix-auth-swift-sdk.git', :tag => 'v0.2.0'
    pod 'Socket.IO-Client-Swift', '~> 10.0.0'
end

target 'MATRIX Streaming SDK macOS' do
    platform :osx, '10.10'
    shared_pods
end

target 'MATRIX Streaming SDK iOS' do
    platform :ios, '8.0'
    shared_pods
end

target 'MATRIX Streaming SDK tvOS' do
    platform :tvos, '9.0'
    shared_pods
end
