//   Copyright 2018 Alex Deem
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import Foundation

public struct Try<SuccessType> {
    private enum _Try {
        case success(SuccessType)
        case error(Error)
    }
    private let _try: _Try

    public init(success: SuccessType) {
        _try = .success(success)
    }

    public init(error: Error) {
        _try = .error(error)
    }

    public init(_ closure: () throws -> SuccessType) {
        do {
            _try = .success(try closure())
        } catch let error {
            _try = .error(error)
        }
    }

    public init<ErrorType>(_ result: Result<SuccessType, ErrorType>) {
        switch result {
        case let .success(value):
            _try = .success(value)
        case let .error(error):
            _try = .error(error)
        }
    }

    public func unwrap() throws -> SuccessType {
        switch _try {
        case let .success(value):
            return value
        case let .error(error):
            throw error
        }
    }

    public func map<TargetSuccessType>(_ transform: (SuccessType) throws -> TargetSuccessType ) rethrows -> Try<TargetSuccessType> {
        switch _try {
        case let .success(value):
            return Try<TargetSuccessType>(success: try transform(value))
        case let .error(error):
            return Try<TargetSuccessType>(error: error)
        }
    }
}
