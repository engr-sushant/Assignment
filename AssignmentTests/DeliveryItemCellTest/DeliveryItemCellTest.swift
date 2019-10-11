import XCTest
@testable import Assignment

class DeliveryItemCellTest: XCTestCase {

    var itemCell: DeliveryItemCell!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        itemCell = DeliveryItemCell()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        itemCell = nil
        super.tearDown()
    }
    
    func testPlotDataWithNilLocation() {
        var item = getDummyItem()
        item.location = nil
        itemCell.plotDataOnCell(withCellItem: item)
        XCTAssertTrue(itemCell.descriptionLbl.text == item.description!)
    }
    
    func testPlotDataWithNilItem() {
        var item = getDummyItem()
        item.description = nil
        item.location?.address = nil
        itemCell.plotDataOnCell(withCellItem: item)
        XCTAssertTrue(itemCell.descriptionLbl.text == kEmptyString)
    }
    
    func testPlotDataWithNotNilItem() {
        let item = getDummyItem()
        itemCell.plotDataOnCell(withCellItem: item)
        XCTAssertTrue(itemCell.descriptionLbl.text != kEmptyString)
    }

}

// MARK: - Extension DeliveryItemCellTest
extension DeliveryItemCellTest {
    
    // MARK: - Get Dummy Item For Test
    func getDummyItem() -> DeliveryItem {
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        return DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
    }
}



