import XCTest
@testable import Assignment

class DeliveryItemViewControllerTest: XCTestCase {

    var allItemVC: DeliveryItemListViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let navigationController = SharedAppDelegate.window?.rootViewController as! UINavigationController
        allItemVC = navigationController.viewControllers[0] as? DeliveryItemListViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        allItemVC = nil
        super.tearDown()
    }
    
    func testSetupNavigationBar() {
        allItemVC.setupNavigationBar()
        XCTAssertNotNil(allItemVC.title)
    }
    
    func testUIElementsShouldNotNil() {
        XCTAssertNotNil(allItemVC.tableView)
        XCTAssertNotNil(allItemVC.navigationController)
    }
    
    func testSetupTableView() {
        allItemVC.setupTableView()
        XCTAssertNotNil(allItemVC.tableView.refreshControl)
        XCTAssertNotNil(allItemVC.tableFooterLoader)
        XCTAssertNotNil(allItemVC.tableView.dequeueReusableCell(withIdentifier: "Cell"))
    }
    
    func testHideLoader() {
        if let footerLoader = allItemVC.tableFooterLoader {
            allItemVC.hideLoader()
            XCTAssertTrue(footerLoader.isHidden)
        }
    }
}
