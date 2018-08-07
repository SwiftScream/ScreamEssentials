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

class AtomicTests: XCTestCase {

    private class TestObject {
        var s: String
        init(_ s: String) {
            self.s = s
        }
    }

    func testReferenceIsWrapped() {
        let object = TestObject("a")
        let a = Atomic(object)
        let aObject = a.perform { $0 }
        XCTAssert(aObject === object)
    }

    func testValueIsCopied() {
        let object = "a"
        let a = Atomic(object)
        let aObject = a.perform { $0 }
        XCTAssert(aObject == object)
    }

    func testReferenceMutation() {
        let object = TestObject("a")
        let a = Atomic(object)
        a.perform { value in
            value.s = "b"
        }
        XCTAssert(object.s == "b")
        let aObject = a.perform { $0.s }
        XCTAssert(aObject == "b")
    }

    func testValueMutation() {
        let object = "a"
        let a = Atomic(object)
        a.perform { value in
            value = "b"
        }
        XCTAssert(object == "a")
        let aObject = a.perform { $0 }
        XCTAssert(aObject == "b")
    }


    func test_GetAndSet() {
        let objectA = TestObject("a")
        let objectB = TestObject("b")
        let a = Atomic(objectA)
        XCTAssert(a.perform { $0 } === objectA)

        let originalValue = a.getAndSet(objectB)
        XCTAssert(objectA === originalValue)
        XCTAssert(a.perform { $0 } === objectB)
    }

    func test_CompareAndSet_WithContention() {
        let a = Atomic(0)
        DispatchQueue.concurrentPerform(iterations: 10000) { (_) in
            a.perform { value in
                value += 1
            }
        }
        XCTAssertEqual(a.perform { $0 }, 10000)
    }

}
