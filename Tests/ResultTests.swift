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

enum ResultTestError: Error {
    case a
    case b
}

class ResultTests: XCTestCase {

    func test_Init_Success() {
        let result: Result<String, ResultTestError> = Result {
            return "A"
        }
        switch result {
        case .success(let value):
            XCTAssertEqual(value, "A")
        case .error:
            XCTFail("Unexpected error case")
        }
    }

    func test_Init_Error() {
        let result: Result<String, ResultTestError> = Result {
            throw ResultTestError.a
        }
        switch result {
        case .success:
            XCTFail("Unexpected success case")
        case .error(let e):
            XCTAssertEqual(e, ResultTestError.a)
        }
    }

    func test_Unwrap_Success() {
        let result: Result<String, ResultTestError> = .success("A")
        do {
            let string = try result.unwrap()
            XCTAssertEqual(string, "A")
        } catch {
            XCTFail("unexpected error case")
        }
    }

    func test_Unwrap_Error() {
        let result: Result<String, ResultTestError> = .error(ResultTestError.b)
        do {
            let string = try result.unwrap()
            XCTFail("unexpected success case, \(string)")
        } catch ResultTestError.b {
        } catch {
            XCTFail("unexpected error case")
        }
    }


}
