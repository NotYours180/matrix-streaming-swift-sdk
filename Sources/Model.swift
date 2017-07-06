//
//  Model.swift
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

private protocol _Optional {
    var wrapped: Any? { get }
}

extension Optional: _Optional {
    var wrapped: Any? {
        return self
    }
}

/// Flattens `Optional<Optional<...>>` into a single `Optional<Any>`.
private func _flatten(_ x: Any) -> Any? {
    if let x = x as? _Optional {
        return x.wrapped.flatMap(_flatten)
    } else {
        return x
    }
}

/// A model from which a thorough dictionary of values can be obtained.
public protocol Model {
    /// A dictionary representation of `self`.
    var dictionary: [String: Any] { get }
}

extension Model {
    /// A dictionary representation of `self`.
    public var dictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        var result = [String: Any](minimumCapacity: Int(mirror.children.count))

        func handle(children: Mirror.Children) {
            for case let (label?, item) in children {
                guard let value = _flatten(item) else {
                    continue
                }
                result[label] = (value as? Model)?.dictionary ?? value
            }
        }

        handle(children: mirror.children)

        if let parent = mirror.superclassMirror {
            handle(children: parent.children)
        }

        return result
    }
}
