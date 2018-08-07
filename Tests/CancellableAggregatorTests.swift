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

class TestCancellable: Cancellable {
    var cancelled: Bool = false
    func cancel() {
        cancelled = true
    }
}

class CancellableAggregatorTests: XCTestCase {

    func testAggregatorCancelsAllAdded() {
        let a = TestCancellable()
        let b = TestCancellable()
        let c = TestCancellable()

        let aggregator = CancellableAggregator()
        XCTAssertTrue(aggregator.add(a))
        XCTAssertTrue(aggregator.add(b))

        XCTAssertFalse(a.cancelled)
        XCTAssertFalse(b.cancelled)
        XCTAssertFalse(c.cancelled)

        aggregator.cancel()

        XCTAssertTrue(a.cancelled)
        XCTAssertTrue(b.cancelled)
        XCTAssertFalse(c.cancelled)
    }

    func testAggregatorCannotAddAfterCancel() {
        let a = TestCancellable()

        let aggregator = CancellableAggregator()
        XCTAssertFalse(a.cancelled)

        aggregator.cancel()

        XCTAssertFalse(a.cancelled)
        XCTAssertFalse(aggregator.add(a))
        XCTAssertFalse(a.cancelled)
    }

    func testAggregatorCancelTwiceNoProblem() {
        let a = TestCancellable()

        let aggregator = CancellableAggregator()
        XCTAssertTrue(aggregator.add(a))
        XCTAssertFalse(a.cancelled)
        aggregator.cancel()
        XCTAssertTrue(a.cancelled)

        aggregator.cancel()
        XCTAssertTrue(a.cancelled)
    }

}
