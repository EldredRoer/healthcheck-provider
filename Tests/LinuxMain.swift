import XCTest

import HealthCheckProviderTests

var tests = [XCTestCaseEntry]()
tests += HealthCheckProviderTests.allTests()
XCTMain(tests)