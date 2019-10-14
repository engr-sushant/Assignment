import XCTest
@testable import Assignment

class CommonClassTest: XCTestCase {

    var commonClass: CommonClass!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        commonClass = CommonClass()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        commonClass = nil
        super.tearDown()
    }

    func testShowLoader() {
        commonClass.isProgressViewAdded = false
        commonClass.showLoader()
        XCTAssertTrue(commonClass.isProgressViewAdded == true)
    }
    
    func testHideLoader() {
        commonClass.isProgressViewAdded = true
        commonClass.hideLoader()
        XCTAssertTrue(commonClass.isProgressViewAdded == false)
    }
}
