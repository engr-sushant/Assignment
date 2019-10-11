import XCTest
@testable import Assignment

class APIManagerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetItemsFromServer() {
        StubObject.request(withPathRegex: "mock-api-mobile.dev.lalamove.com", withResponseFile: "ItemsList.json")
        let expectedResult = expectation(description: "got result")
        APIManager().getItemsFromServer(offset: 0, limit: FetchLimit) { (items, err) in
            if let items = items {
                //Success
                XCTAssertEqual(2, items.count)
                expectedResult.fulfill()
            } else if let err = err {
                //Failure
                XCTAssertNotNil(err, "Failed to get response from server")
            }
        }
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                XCTAssertNotNil(error, "Failed to get response from list webservice")
            }
        }
    }
    
    func testGetItemsFromServerWithErr() {
        StubObject.request(withPathRegex: "mock-api-mobile.dev.lalamove.com", withResponseFile: "InvalidResponse.json")
        let expectedResult = expectation(description: "got invalid")
        APIManager().getItemsFromServer(offset: 0, limit: FetchLimit) { (items, err) in
            if let items = items {
                XCTAssertNil(items, "error: item should be nil")
            } else if let err = err {
                //Failure
                XCTAssertNotNil(err, "error: Expectation fulfilled with error")
            }
            expectedResult.fulfill()
        }

        waitForExpectations(timeout: 60) { error in
            if let error = error {
                XCTAssertNotNil(error, "Failed to get response from server")
            }
        }
    }
}
