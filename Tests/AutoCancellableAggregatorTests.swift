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

class TestAutoCancellable: AutoCancellable {
    var cancelOnDeinit: Bool = true
    var cancelled: Bool = false
    let cancelBlock: () -> Void

    init(_ cancelBlock: @escaping () -> Void = {}) {
        self.cancelBlock = cancelBlock
    }

    deinit {
        if cancelOnDeinit {
            cancel()
        }
    }

    func cancel() {
        cancelled = true
        cancelBlock()
    }
}

class AutoCancellableAggregatorTests: XCTestCase {

    func testAggregatorCancelsAllAdded() {
        let a = TestAutoCancellable()
        let b = TestAutoCancellable()
        let c = TestAutoCancellable()

        let aggregator = AutoCancellableAggregator()
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
        let a = TestAutoCancellable()

        let aggregator = AutoCancellableAggregator()
        XCTAssertFalse(a.cancelled)

        aggregator.cancel()

        XCTAssertFalse(a.cancelled)
        XCTAssertFalse(aggregator.add(a))
        XCTAssertFalse(a.cancelled)
    }

    func testAggregatorCancelTwiceNoProblem() {
        let a = TestAutoCancellable()

        let aggregator = AutoCancellableAggregator()
        XCTAssertTrue(aggregator.add(a))
        XCTAssertFalse(a.cancelled)
        aggregator.cancel()
        XCTAssertTrue(a.cancelled)

        aggregator.cancel()
        aggregator.cancelOnDeinit = false
        XCTAssertTrue(a.cancelled)
    }

    func testAggregatorCancelsOnDeinit() {
        var aCancelled = false
        var bCancelled = false

        let closure = {
            let a = TestAutoCancellable({
                aCancelled = true
            })
            let b = TestAutoCancellable({
                bCancelled = true
            })

            let aggregator = AutoCancellableAggregator()
            XCTAssertTrue(aggregator.add(a))
            XCTAssertTrue(aggregator.add(b))

            XCTAssertFalse(a.cancelled)
            XCTAssertFalse(b.cancelled)
        }

        closure()

        XCTAssertTrue(aCancelled)
        XCTAssertTrue(bCancelled)
    }

    func testAggregatorNoCancelOnDeinitIfNotEnabled() {
        var aCancelled = false
        var bCancelled = false

        let closure = {
            let a = TestAutoCancellable({
                aCancelled = true
            })
            let b = TestAutoCancellable({
                bCancelled = true
            })

            let aggregator = AutoCancellableAggregator()
            XCTAssertTrue(aggregator.add(a))
            aggregator.cancelOnDeinit = false
            XCTAssertTrue(aggregator.add(b))

            XCTAssertFalse(a.cancelled)
            XCTAssertFalse(b.cancelled)
        }

        closure()

        XCTAssertFalse(aCancelled)
        XCTAssertFalse(bCancelled)
    }

}
