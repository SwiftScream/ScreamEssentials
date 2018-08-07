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

final public class CancellableAggregator: Cancellable {
    private var cancellables: Atomic<[Cancellable]?>

    public init() {
        self.cancellables = Atomic([])
    }

    public func cancel() {
        let cancellables = self.cancellables.getAndSet(nil)
        guard let finalCancellables = cancellables else {
            return
        }
        for cancellable in finalCancellables {
            cancellable.cancel()
        }
    }

    public func add(_ cancellable: Cancellable) -> Bool {
        return self.cancellables.perform { (value) -> Bool in
            if var cancellables = value {
                cancellables.append(cancellable)
                value = cancellables
                return true
            }
            return false
        }
    }
}

final public class AutoCancellableAggregator: AutoCancellable {
    private var cancellables: Atomic<[AutoCancellable]?>

    public init() {
        self.cancellables = Atomic([])
        self.cancelOnDeinit = true
    }

    public func cancel() {
        let cancellables = self.cancellables.getAndSet(nil)
        guard let finalCancellables = cancellables else {
            return
        }
        for cancellable in finalCancellables {
            cancellable.cancel()
        }
    }

    public var cancelOnDeinit: Bool {
        didSet {
            let cancellables = self.cancellables.perform { $0 }
            guard let currentCancellables = cancellables else {
                return
            }
            for var cancellable in currentCancellables {
                cancellable.cancelOnDeinit = cancelOnDeinit
            }
        }
    }

    public func add(_ c: AutoCancellable) -> Bool {
        var cancellable = c
        cancellable.cancelOnDeinit = self.cancelOnDeinit
        return self.cancellables.perform { (value) -> Bool in
            if var cancellables = value {
                cancellables.append(cancellable)
                value = cancellables
                return true
            }
            return false
        }
    }
}
