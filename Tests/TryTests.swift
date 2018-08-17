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

enum TryTestError: Error {
    case a
    case b
}

class TryTests: XCTestCase {

    func test_Init_Success() {
        let result = Try(success: "A")
        do {
            let string = try result.unwrap()
            XCTAssertEqual(string, "A")
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_Init_Error() {
        let result = Try<String>(error: TryTestError.b)
        do {
            let string = try result.unwrap()
            XCTFail("unexpected success case, \(string)")
        } catch TryTestError.b {
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_InitWithResult_Success() {
        let result: Result<String, TryTestError> = .success("A")
        let t = Try(result)
        do {
            let string = try t.unwrap()
            XCTAssertEqual(string, "A")
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_InitWithResult_Error() {
        let result: Result<String, TryTestError> = .error(TryTestError.b)
        let t = Try(result)
        do {
            let string = try t.unwrap()
            XCTFail("unexpected success case, \(string)")
        } catch TryTestError.b {
        } catch {
            XCTFail("unexpected error case")
        }
    }


    func test_Unwrap_Success() {
        let result: Try<String> = Try {
            return "A"
        }
        do {
            let string = try result.unwrap()
            XCTAssertEqual(string, "A")
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_Unwrap_Error() {
        let result: Try<String> = Try {
            throw TryTestError.b
        }
        do {
            let string = try result.unwrap()
            XCTFail("unexpected success case, \(string)")
        } catch TryTestError.b {
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_Map_Success() {
        let result = Try(success: 12)
        do {
            let doubled = result.map { 2 * $0 }
            let value = try doubled.unwrap()
            XCTAssertEqual(value, 24)
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_Map_Error() {
        let result = Try<Int>(error: TryTestError.b)
        do {
            let doubled = result.map { 2 * $0 }
            let value = try doubled.unwrap()
            XCTFail("unexpected success case, \(value)")
        } catch TryTestError.b {
        } catch {
            XCTFail("unexpected error case")
        }
    }

}
