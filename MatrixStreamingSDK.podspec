Pod::Spec.new do |s|
    s.name                      = "MatrixStreamingSDK"
    s.version                   = "2.0.0"
    s.summary                   = "MATRIX Streaming SDK for Swift."
    s.homepage                  = "https://github.com/matrix-io/matrix-streaming-swift-sdk"
    s.license                   = { :type => "MIT", :file => "LICENSE.md" }
    s.author                    = "MATRIX Labs"
    s.social_media_url          = "https://twitter.com/MATRIX_Creator"
    s.ios.deployment_target     = "8.0"
    s.osx.deployment_target     = "10.10"
    s.tvos.deployment_target    = '9.0'
    s.source                    = { :git => "#{s.homepage}.git", :tag => "v#{s.version}" }
    s.source_files              = "Sources/**/*.swift"
    s.dependency "MatrixUtils"
    s.dependency "Socket.IO-Client-Swift", "~> 12.1.0"
end
