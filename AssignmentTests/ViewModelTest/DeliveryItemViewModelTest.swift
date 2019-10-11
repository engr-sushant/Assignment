import XCTest
import CoreData
@testable import Assignment

class DeliveryItemViewModelTest: XCTestCase {

    // MARK: - VARIABLES
    var allItemVM: DeliveryItemViewModel?
    var mockapimanager: MockAPIManager!
    var mockcoredatamanager = MockCoreDataManager.mocksharedManager

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        allItemVM = DeliveryItemViewModel()
        allItemVM?.coreDataManager = mockcoredatamanager
        mockcoredatamanager.shouldReturnErr = false
        mockcoredatamanager.shouldReturnEmptyData = false
        mockapimanager = MockAPIManager()
        allItemVM?.apiManager = mockapimanager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        allItemVM = nil
        mockapimanager = nil
        super.tearDown()
    }
    
    func testLoadDataFromServerWithSuccess() {
        if let allItemVM = allItemVM {
            mockcoredatamanager.shouldReturnEmptyData = true //to make sure we do not get data from database and we hit api to get data
            allItemVM.isLoading = false
            allItemVM.loadDataOnTableView()
            XCTAssertTrue(allItemVM.allItemArray.count == 1)
        }
    }
    
    func testRefreshWithSuccess() {
        if let allItemVM = allItemVM {
            let item = getDummyItem()
            allItemVM.allItemArray = [item, item] //on refresh array count will change
            mockcoredatamanager.shouldReturnEmptyData = true
            allItemVM.refreshTableViewData()
            XCTAssertTrue(allItemVM.allItemArray.count == 1)
        }
    }
    
    func testItemDetailModel() {
        allItemVM?.allItemArray = [getDummyItem()]
        let itemDetailVM = allItemVM?.getItemDetailViewModel(fromIndex: 0)
        XCTAssertNotNil(itemDetailVM?.item)
    }
    
    func testNilItemDetailModel() {
        allItemVM?.allItemArray = [getDummyItem()]
        let itemDetailVM = allItemVM?.getItemDetailViewModel(fromIndex: 1)
        XCTAssertNil(itemDetailVM?.item)
    }

}

//MARK:- Extension DeliveryItemViewModelTest
extension DeliveryItemViewModelTest {
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


// MARK: - MOCK API MANAGER
class MockAPIManager: APIManagerProtocol {
    
    var errorInResp = false
    
    // MARK: - API TO GET ITEM LIST FROM SERVER
    func getItemsFromServer(offset: Int, limit: Int, completionBlock: @escaping APIManager.GetItemsFromServerCompletion) {
        if errorInResp {
            let error = NSError(domain: "Error", code: 400, userInfo: nil)
            completionBlock(nil,error)
            return
        } else {
            let item = getDummyItem()
            completionBlock([item],nil)
        }
    }
    
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
// MARK: - MOCK CORE DATA MANAGER
class MockCoreDataManager: CoredataManagerProtocol {
    
    static let mocksharedManager = MockCoreDataManager()
    var shouldReturnEmptyData: Bool!
    var shouldReturnErr: Bool!
    
    func fetchItemFromDatabase(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void)) {
        // Failure
        guard !shouldReturnErr else {
            //return error
            completion([], CustomError.customError)
            return
        }
        
        // Success
        guard !shouldReturnEmptyData else {
            //return blank data
            completion([DeliveryItem](), nil)
            return
        }
        
        //return data
        let itemDic: [String: Any] = [kId: 38,
                                      kDescription  : "Deliver food to Eric",
                                      kImageUrl     : "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg",
                                      kLocation     : [kLatitude    : 22.319181,
                                                       kLongitude   : 114.170008,
                                                       kAddress     : "Mong Kok"
            ]
        ]
        let item = DeliveryItem.init(withJson: itemDic)
        completion([item], nil)
    }
    
    func deleteItemData(completion: @escaping ((Error?) -> Void)) {
        //mock delete
    }
    
    func saveItemToLocalDB(items: [DeliveryItem]) {
        //mock save
    }
}

// MARK: - MOCK CONECTIVITY
class MockReachability: CommonClass {
    override func isInternetConnected() -> Bool {
        return true
    }
}

// MARK: - MOCK ERROR
public enum CustomError: Error {
    case customError
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return "Exception for testing"
        }
    }
}

