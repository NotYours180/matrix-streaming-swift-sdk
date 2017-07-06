//
//  MXSSQuery.swift
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

/// A MATRIX Streaming Service query.
public final class MXSSQuery: Model {

    public enum Interval: String {

        case now

        case hour

        case day

        case week

        case month
        
        case year

    }

    /// The date formatter used.
    private static let _dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    public var interval: String

    public var app: String

    public var version: String

    public var fields: [String]

    public var start: String

    public var end: String

    public var device: String

    public var userId: String

    public var config: [String: Any]

    public var timezoneOffset: Int

    public var export: Bool

    public init(interval: Interval,
                app: String,
                version: String,
                fields: [String],
                start: Date,
                end: Date,
                device: String,
                userId: String,
                config: [String: Any],
                timezoneOffset: Int,
                export: Bool) {
        let formatter = MXSSQuery._dateFormatter

        self.interval       = interval.rawValue
        self.app            = app
        self.version        = version
        self.fields         = fields
        self.start          = formatter.string(from: start)
        self.end            = formatter.string(from: end)
        self.device         = device
        self.userId         = userId
        self.config         = config
        self.timezoneOffset = timezoneOffset
        self.export         = export
    }

}
