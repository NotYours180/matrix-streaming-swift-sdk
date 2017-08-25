//
//  MXSSConnection.swift
//  MATRIX Streaming SDK
//
//  MIT License
//
//  Copyright (c) 2017 MATRIX Labs
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import SocketIO
import MatrixUtils

/// MATRIX Streaming socket connection delegate.
@objc public protocol MXSSConnectionDelegate: class {

    /// The MATRIX Streaming connection receive a message.
    @objc optional func MXSSConnectionMessage(data: [String:AnyObject])

    /// The MATRIX Streaming connection receive a aggregation message.
    @objc optional func MXSSConnectionAggregation(data: [String:AnyObject])

    /// The MATRIX Streaming connection did changed
    func MXSSConnectionConnectionDidChanged(status: Bool)
}

/// A MATRIX Streaming socket connection.
public final class MXSSConnection {

    internal var _baseURL: URL

    internal var _userId: String

    internal var _userToken: String

    internal var _waitingReconnection: Bool

    fileprivate var _isConnected: Bool {
        didSet {
            self.delegate?.MXSSConnectionConnectionDidChanged(status: _isConnected)
        }
    }

    /// The delegate.
    public weak var delegate: MXSSConnectionDelegate? {
        didSet {
            self.delegate?.MXSSConnectionConnectionDidChanged(status: _isConnected)
        }
    }

    fileprivate var _engine: SocketEngine?


    /// Creates an instance for a given environment, user ID, and user token.
    ///
    /// - throws: `MatrixAuth.Error` if the ID or token are invalid (e.g. empty).
    public convenience init(env: Environment = .prod, userId: String, userToken: String) throws {
        try self.init(baseURL: env.MXSSURL.absoluteString, userId: userId, userToken: userToken)
    }

    /// Creates an instance with a base URL, user ID, and user token.
    ///
    /// - throws: `MXSSConnection.Error` if any parameter is invalid (e.g. empty)
    public init(baseURL: String, userId: String, userToken: String) throws {
        guard !baseURL.isEmpty else {
            throw Error.invalidBaseURL
        }
        guard !userId.isEmpty else {
            throw Error.invalidUserID
        }
        guard !userToken.isEmpty else {
            throw Error.invalidUserToken
        }
        _baseURL = URL(string: baseURL)!
        _userId = userId
        _userToken = userToken
        _waitingReconnection = false
        _isConnected = false
    }

    deinit {
        _engine?.disconnect(reason: "Manually Disconnected")
        _engine = nil
    }

    /// Starts the MATRIX Streaming server connection.
    public func startConnection() {
            let options = ["path": "/engine.io",
                           "log": true,
                           "forceWebsockets": false,
                           "secure": _baseURL.absoluteString.contains("wss") ? true : false] as NSDictionary
            _engine = SocketEngine(client: self, url: _baseURL, options: options)
            _engine?.connect()
    }

    /// Stops the MATRIX Streaming server connection.
    public func stopConnection() {
        _engine?.disconnect(reason: "Manually Disconnected")
    }

    /// Send a message to MATRIX Streaming server.
    public func sendMessage(_ message: Data) {
        if _engine?.connected == true && _isConnected == true {
            _engine?.write("", withType: .message, withData: [message])
        }
    }

    /// Register this connection as client on the MATRIX Streaming server.
    fileprivate func registerClient() {
        let message = ["channel": MXSSEvent.clientRegister.rawValue,
                       "payload": ["userId": _userId, "userToken": _userToken]] as Dictionary
        if let jsonData = message.data {
            _engine?.write("", withType: .message, withData: [jsonData])
            print("write \(MXSSEvent.clientRegister.rawValue)")
        }
    }
}

// MARK: SocketEngineClient
extension MXSSConnection: SocketEngineClient {

    public func engineDidError(reason: String) { }

    public func engineDidClose(reason: String) {
        self._isConnected = false
        if reason == "Manually Disconnected" {
            self._engine = nil
        } else {
            if !_waitingReconnection {
                _waitingReconnection = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    self._engine?.connect()
                    self._waitingReconnection = false
                })
            }
        }
    }

    public func engineDidOpen(reason: String) {
        self.registerClient()
    }

    public func parseEngineMessage(_ message: String) {
        if let dictionary = message.getDictionary() {
            if let channelName = dictionary["channel"] as? String {
                switch channelName {
                case "register-ok":
                    self._isConnected = true
                    print("register-ok")
                case "register-fail":
                    stopConnection()
                    print("register-fail")
                case "server-message":
                    if let payload = dictionary["payload"] as? [String : AnyObject] {
                        self.delegate?.MXSSConnectionMessage?(data: payload)
                    }
                case "server-aggregation":
                    if let payload = dictionary["payload"] as? [String : AnyObject] {
                        self.delegate?.MXSSConnectionAggregation?(data: payload)
                    }
                default:
                    print(channelName)
                }
            }
        }
    }

    public func parseEngineBinaryData(_ data: Data) { }
}
