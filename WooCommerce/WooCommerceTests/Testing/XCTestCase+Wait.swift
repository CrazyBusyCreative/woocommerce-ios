
import XCTest

extension XCTestCase {
    /// Creates an XCTestExpectation and waits for `block` to call `fulfill()`.
    ///
    /// Example usage:
    ///
    /// ```
    /// waitForExpectation(timeout: TimeInterval(10)) { expectation in
    ///     doSomethingInTheBackground {
    ///         expectation.fulfill()
    ///     }
    /// }
    /// ```
    ///
    func waitForExpectation(description: String? = nil,
                            timeout: TimeInterval = Constants.expectationTimeout,
                            _ block: (XCTestExpectation) -> ()) {
        let exp = expectation(description: description ?? "")
        block(exp)
        wait(for: [exp], timeout: timeout)
    }

    /// Creates an `XCTestExpectation` and waits until `condition` returns `true`.
    ///
    /// Example usage:
    ///
    /// ```
    /// var valueThatIsUpdatedAsynchronously: Int = 0
    ///
    /// waitUntil {
    ///     valueThatIsUpdatedAsynchronously > 5
    /// }
    /// ```
    ///
    func waitUntil(condition: @escaping () -> Bool, timeout: TimeInterval = Constants.expectationTimeout) {
        let predicate = NSPredicate { _, _ -> Bool in
            return condition()
        }

        let exp = expectation(for: predicate, evaluatedWith: nil)

        wait(for: [exp], timeout: timeout)
    }
}
