import XCTest
@testable import Assignment

class DeliveryItemCellTest: XCTestCase {

    var itemCell: DeliveryItemTableViewCell!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        itemCell = DeliveryItemTableViewCell()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        itemCell = nil
        super.tearDown()
    }
    
    func testPlotDataWithNilImageURL() {
        var item = getDummyItem()
        item.imageUrl = nil
        itemCell.plotDataOnCell(withCellItem: item)
        XCTAssertTrue(itemCell.cellImageView.image == AppPlaceholderImage)
    }
    
    func testPlotDataWithNilLocation() {
        var item = getDummyItem()
        item.location = nil
        itemCell.plotDataOnCell(withCellItem: item)
        XCTAssertTrue(itemCell.descriptionLbl.text == item.itemDescription!)
    }
    
    func testPlotDataWithNilItem() {
        var item = getDummyItem()
        item.itemDescription = nil
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

//MARK:- Extension DeliveryItemCellTest
extension DeliveryItemCellTest {
    //MARK:- Get Dummy Item For Test
    func getDummyItem() -> DeliveryItem {
        let itemDic: [String: Any] = [kId: 38,
                                      kDescription  : "Deliver food to Eric",
                                      kImageUrl     : "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg",
                                      kLocation     : [kLatitude    : 22.319181,
                                                       kLongitude   : 114.170008,
                                                       kAddress     : "Mong Kok"
            ]
        ]
        return DeliveryItem.init(withJson: itemDic)
    }
}



