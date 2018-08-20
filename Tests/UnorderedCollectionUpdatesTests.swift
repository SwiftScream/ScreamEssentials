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

import XCTest
import ScreamEssentials


public class UnorderedCollectionUpdatesTestsDifferentType: XCTestCase {
    class StringWrapper: Equatable {
        let string: String

        init(_ string: String) {
            self.string = string
        }

        static func == (lhs: UnorderedCollectionUpdatesTestsDifferentType.StringWrapper, rhs: UnorderedCollectionUpdatesTestsDifferentType.StringWrapper) -> Bool {
            return lhs.string == rhs.string
        }
    }

    func testEmptyToEmpty() {
        let a: [String] = []
        let b: [StringWrapper] = []
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, [])
    }

    func testEmptyToNotEmpty() {
        let a: [String] = []
        let b: [StringWrapper] = [StringWrapper("a"), StringWrapper("b")]
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [StringWrapper("a"), StringWrapper("b")])
        XCTAssertEqual(updates.remove, [])
    }

    func testNotEmptyToEmpty() {
        let a: [String] = ["a", "b"]
        let b: [StringWrapper] = []
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, ["a", "b"])
    }

    func testNoChange() {
        let a: [String] = ["a", "b"]
        let b: [StringWrapper] = [StringWrapper("a"), StringWrapper("b")]
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, [])
    }

    func testAdd1Remove0() {
        let a: [String] = ["a", "b"]
        let b: [StringWrapper] = [StringWrapper("a"), StringWrapper("c"), StringWrapper("b")]
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [StringWrapper("c")])
        XCTAssertEqual(updates.remove, [])
    }

    func testAdd0Remove1() {
        let a: [String] = ["a", "b"]
        let b: [StringWrapper] = [StringWrapper("a")]
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, ["b"])
    }

    func testAdd1Remove1() {
        let a: [String] = ["a", "b"]
        let b: [StringWrapper] = [StringWrapper("a"), StringWrapper("c")]
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, [StringWrapper("c")])
        XCTAssertEqual(updates.remove, ["b"])
    }

    func testDistinctSets() {
        let a: [String] = ["a", "b"]
        let b: [StringWrapper] = [StringWrapper("x"), StringWrapper("y")]
        let updates = UnorderedCollectionUpdates(old: a, new: b, comparator: { $0 == $1.string })
        XCTAssertEqual(updates.add, b)
        XCTAssertEqual(updates.remove, a)
    }

}

public class UnorderedCollectionUpdatesTestsSameType: XCTestCase {

    func testEmptyToEmpty() {
        let a: [String] = []
        let b: [String] = []
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, [])
    }

    func testEmptyToNotEmpty() {
        let a: [String] = []
        let b: [String] = ["a", "b"]
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, ["a", "b"])
        XCTAssertEqual(updates.remove, [])
    }

    func testNotEmptyToEmpty() {
        let a: [String] = ["a", "b"]
        let b: [String] = []
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, ["a", "b"])
    }

    func testNoChange() {
        let a: [String] = ["a", "b"]
        let b: [String] = ["a", "b"]
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, [])
    }

    func testAdd1Remove0() {
        let a: [String] = ["a", "b"]
        let b: [String] = ["a", "c", "b"]
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, ["c"])
        XCTAssertEqual(updates.remove, [])
    }

    func testAdd0Remove1() {
        let a: [String] = ["a", "b"]
        let b: [String] = ["a"]
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, [])
        XCTAssertEqual(updates.remove, ["b"])
    }

    func testAdd1Remove1() {
        let a: [String] = ["a", "b"]
        let b: [String] = ["a", "c"]
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, ["c"])
        XCTAssertEqual(updates.remove, ["b"])
    }

    func testDistinctSets() {
        let a: [String] = ["a", "b"]
        let b: [String] = ["x", "y"]
        let updates = UnorderedCollectionUpdates(old: a, new: b)
        XCTAssertEqual(updates.add, b)
        XCTAssertEqual(updates.remove, a)
    }

}
