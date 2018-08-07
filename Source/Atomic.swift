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

final public class Atomic<T> {
    private var value: T
    let semaphore: DispatchSemaphore

    public init(_ value: T) {
        self.value = value
        self.semaphore = DispatchSemaphore(value: 1)
    }

    public func perform<ReturnType>(_ block: (inout T) throws -> ReturnType) rethrows -> ReturnType {
        self.semaphore.wait(); defer { self.semaphore.signal() }
        return try block(&value)
    }

    public func getAndSet(_ value: T) -> T {
        self.semaphore.wait(); defer { self.semaphore.signal() }
        let old = self.value
        self.value = value
        return old
    }
}
