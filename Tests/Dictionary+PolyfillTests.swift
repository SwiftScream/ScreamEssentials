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

class DictionaryPolyfillTests: XCTestCase {

    func testCompactMapValues() {
        let dict = ["A": 0,
                    "B": 1,
                    "C": 2,
                    "D": 3,
                    "E": 4,
                    "F": 5,
                    "G": 6,
                    ]
        let expected = ["B": "a1",
                        "D": "a3",
                        "F": "a5",
                        ]

        let result = dict.compactMapValues { (value) -> String? in
            if value % 2 == 0 {
                return nil
            }
            return "a\(value)"
        }

        XCTAssertEqual(expected, result)
    }

}
