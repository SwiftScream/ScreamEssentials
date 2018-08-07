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

final private class DispatchWorkItemCancellable: AutoCancellable {
    public var cancelOnDeinit: Bool = true
    fileprivate let workItem: DispatchWorkItem

    init(workItem: DispatchWorkItem) {
        self.workItem = workItem
    }

    deinit {
        if cancelOnDeinit {
            cancel()
        }
    }

    public func cancel() {
        self.workItem.cancel()
    }
}

extension DispatchQueue {
    public func asyncCancellable(block: @escaping () -> Void) -> AutoCancellable {
        let cancellable = DispatchWorkItemCancellable(workItem: DispatchWorkItem(block: block))
        self.async(execute: cancellable.workItem)
        return cancellable
    }
    public func asyncAfterCancellable(deadline: DispatchTime, block: @escaping () -> Void) -> AutoCancellable {
        let cancellable = DispatchWorkItemCancellable(workItem: DispatchWorkItem(block: block))
        self.asyncAfter(deadline: deadline, execute: cancellable.workItem)
        return cancellable
    }
}
