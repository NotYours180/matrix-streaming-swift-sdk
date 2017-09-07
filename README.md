# MATRIX Swift Streaming SDK
MATRIX Streaming server framework for Swift

[![Build Status](https://travis-ci.org/matrix-io/matrix-streaming-swift-sdk.svg?branch=master)](https://travis-ci.org/matrix-io/matrix-streaming-swift-sdk)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MatrixStreamimgSDK.svg)](https://img.shields.io/cocoapods/v/MatrixStreamimgSDK.svg)
[![License](https://img.shields.io/cocoapods/l/ImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/ImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/ImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/ImagePicker)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)
## Requirements

- iOS 8.0+
- Xcode 8.1, 8.2, 8.3
- Swift 3.0, 3.1, 3.2

## Installation

### CocoaPods

To integrate MATRIX Streaming SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
$ pod 'MatrixStreamimgSDK'
```

Then, run the following command:

```bash
$ pod install
```
## Usage

The starting point is `MXSSConnection`. With it you can:
- Connect to MATRIX Straming Server.
- Authenticate an existing user and work with it.
- Receive messages from a MATRIX device.
- Send events to a MATRIX device.

### Connect to MATRIX Streaming Server

```swift
let mxssConnection = try MXSSConnection(env: ..., userId: ..., userToken: ..., debug: ...)
mxssConnection?.delegate = self
mxssConnection?.startConnection()
```

### Start an app

```swift
let message = ["channel": MXSSEvent.clientCommand,
               "payload": ["t": MXSSCommand.appStart,
                           "deviceId": ...,
                           "p": ["name": /*appName*/,
                                 "token": /*userToken*/]]] as [String : Any]
mxssConnection.sendMessage(message)
```

### Stop an app

```swift
let message = ["channel": MXSSEvent.clientCommand,
               "payload": ["t": MXSSCommand.appStop,
                           "deviceId": ...,
                           "p": ["name": /*appName*/,
                                 "token": /*userToken*/]]] as [String : Any]
mxssConnection.sendMessage(message)
```

## License

This project is released under the [MIT License](LICENSE.md).