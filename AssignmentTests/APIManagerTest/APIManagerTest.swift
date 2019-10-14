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
    
    func testGetDeliveriesFromServer() {
        StubObject.request(withPathRegex: "mock-api-mobile.dev.lalamove.com", withResponseFile: "ItemsList.json")
        let expectedResult = expectation(description: "got result")
        APIManager().getDeliveriesFromServer(offset: 0, limit: APIQueryConstant.fetchLimit) { (result) in
            switch result {
            case .success(let items):
                XCTAssertEqual(2, items.count)
                expectedResult.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error, "Failed to get response from server")
            }
        }
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                XCTAssertNotNil(error, "Failed to get response from list webservice")
            }
        }
    }
    
    func testGetDeliveriesFromServerWithErr() {
        StubObject.request(withPathRegex: "mock-api-mobile.dev.lalamove.com", withResponseFile: "InvalidResponse.json")
        let expectedResult = expectation(description: "got invalid")
        APIManager().getDeliveriesFromServer(offset: 0, limit: APIQueryConstant.fetchLimit) { (result) in
            switch result {
            case .success( let item):
                XCTAssertNil(item, "error: item should be nil")
            case .failure(let error):
                XCTAssertNotNil(error, "error: Expectation fulfilled with error")
                expectedResult.fulfill()
            }
        }

        waitForExpectations(timeout: 60) { error in
            if let error = error {
                XCTAssertNotNil(error, "Failed to get response from server")
            }
        }
    }
}
