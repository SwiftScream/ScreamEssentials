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

public struct UnorderedCollectionUpdates<A, B> where A: Sequence, B: Sequence {
    public init(old: A, new n: B, comparator: (A.Element, B.Element) -> Bool) {
        // partition new into existing and added
        var new = Array(n)
        let boundary = new.partition { newElement in
            old.contains(where: { comparator($0, newElement) })
        }
        let existing = new[boundary...]
        self.add = Array(new[..<boundary])

        // filter old to remove existing to get remove
        self.remove = old.filter { oldElement in
            !existing.contains(where: { comparator(oldElement, $0) })
        }
    }

    public let remove: [A.Element]
    public let add: [B.Element]
}

extension UnorderedCollectionUpdates where A.Element == B.Element, A.Element: Equatable {
    public init(old: A, new n: B) {
        // partition new into existing and added
        var new = Array(n)
        let boundary = new.partition { newElement in
            old.contains(newElement)
        }
        let existing = new[boundary...]
        self.add = Array(new[..<boundary])

        // filter old to remove existing to get remove
        self.remove = old.filter { oldElement in
            !existing.contains(oldElement)
        }
    }
}
