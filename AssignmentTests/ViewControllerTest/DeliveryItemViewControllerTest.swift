import XCTest
@testable import Assignment

class DeliveryItemViewControllerTest: XCTestCase {

    var deliveryItemVC: DeliveryItemListViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let navigationController = sharedAppDelegate.window?.rootViewController as! UINavigationController
        deliveryItemVC = navigationController.viewControllers[0] as? DeliveryItemListViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deliveryItemVC = nil
        super.tearDown()
    }
    
    func testSetupNavigationBar() {
        deliveryItemVC.setupNavigationBar()
        XCTAssertNotNil(deliveryItemVC.title)
    }
    
    func testUIElementsShouldNotNil() {
        XCTAssertNotNil(deliveryItemVC.tableView)
        XCTAssertNotNil(deliveryItemVC.navigationController)
    }
    
    func testSetupTableView() {
        deliveryItemVC.setupTableView()
        XCTAssertNotNil(deliveryItemVC.tableView.refreshControl)
        XCTAssertNotNil(deliveryItemVC.tableFooterLoader)
        XCTAssertNotNil(deliveryItemVC.tableView.dequeueReusableCell(withIdentifier: "Cell"))
    }
    
    func testHideLoader() {
        deliveryItemVC.updateLoader()
        XCTAssertTrue(deliveryItemVC.tableFooterLoader.isHidden)
    }
    
    func testSetupCompletionHandlers() {
        deliveryItemVC.setupCompletionHandlers()
        XCTAssertNotNil(deliveryItemVC.viewModel.handleCompletionWithSuccess)
        XCTAssertNotNil(deliveryItemVC.viewModel.handleCompletionWithNoData)
        XCTAssertNotNil(deliveryItemVC.viewModel.handleCompletionWithError)
        XCTAssertNotNil(deliveryItemVC.viewModel.handleNextPageLoading)
        XCTAssertNotNil(deliveryItemVC.viewModel.handleInternetError)
    }
}
