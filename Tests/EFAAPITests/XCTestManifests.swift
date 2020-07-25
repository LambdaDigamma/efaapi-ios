import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EFAAPITests.allTests),
        testCase(TransportTypeTests.allTests),
    ]
}
#endif
