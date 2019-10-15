import XCTest
@testable import Assignment

class DeliveryDetailViewControllerTest: XCTestCase {

    var itemDetailVC: DeliveryDetailViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        itemDetailVC = DeliveryDetailViewController()
        let viewModel = DeliveryDetailViewModel.init(withItem: getDummyItem())
        itemDetailVC.itemDetailVM = viewModel
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        itemDetailVC = nil
        super.tearDown()
    }
    
    func testSetupNavigationBar() {
        itemDetailVC.setupNavigationBar()
        XCTAssertNotNil(itemDetailVC.title)
    }
    
    func testUIElementsShouldNotNil() {
        itemDetailVC.setupUIElements()
        XCTAssertNotNil(itemDetailVC.itemDetailVM)
        XCTAssertNotNil(itemDetailVC.itemDetailVM.item)
        XCTAssertNotNil(itemDetailVC.itemImageView)
        XCTAssertNotNil(itemDetailVC.itemDescriptionLbl)
        XCTAssertNotNil(itemDetailVC.borderView)
        XCTAssertNotNil(itemDetailVC.mapView)
    }

    func testSetupMapView() {
        itemDetailVC.setupMapView()
        XCTAssertNotNil(itemDetailVC.mapView.selectedMarker)
    }
    
    func testPlotDataWithNilLocation() {
        itemDetailVC.itemDetailVM.item.location = nil
        itemDetailVC.plotData()
        XCTAssertTrue(itemDetailVC.itemDescriptionLbl.text == itemDetailVC.itemDetailVM.item.description)
    }
    
    func testPlotDataWithNilItemDescription() {
        itemDetailVC.itemDetailVM.item.description = nil
        itemDetailVC.plotData()
        XCTAssertTrue(itemDetailVC.itemDescriptionLbl.text == AppConstants.kEmptyString)
    }
}

// MARK: - Extension DeliveryDetailViewControllerTest
extension DeliveryDetailViewControllerTest {
    
    // MARK: - Get Dummy Item For Test
    func getDummyItem() -> DeliveryItem {
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        return DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
    }
}
