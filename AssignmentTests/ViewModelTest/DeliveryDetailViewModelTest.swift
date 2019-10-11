import XCTest
@testable import Assignment

class DeliveryDetailViewModelTest: XCTestCase {

    var itemDetailVM: DeliveryDetailViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        itemDetailVM = DeliveryDetailViewModel.init(withItem: getDummyItem())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        itemDetailVM = nil
        super.tearDown()
    }
    
    func testItemShouldNotNil() {
        XCTAssertNotNil(itemDetailVM.item)
    }
}

// MARK: - Extension DeliveryDetailViewModelTest
extension DeliveryDetailViewModelTest {
    
    // MARK: - Get Dummy Item For Test
    func getDummyItem() -> DeliveryItem {
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        return DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
    }
}

