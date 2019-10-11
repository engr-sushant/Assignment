import XCTest
import CoreData
@testable import Assignment

class DeliveryItemViewModelTest: XCTestCase {

    // MARK: - VARIABLES
    var viewModel: DeliveryItemViewModel?
    var mockapimanager: MockAPIManager!
    var mockcoredatamanager = MockCoreDataManager.mocksharedManager

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        viewModel = DeliveryItemViewModel()
        viewModel?.coreDataManager = mockcoredatamanager
        mockcoredatamanager.shouldReturnErr = false
        mockcoredatamanager.shouldReturnEmptyData = false
        mockapimanager = MockAPIManager()
        viewModel?.apiManager = mockapimanager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockapimanager = nil
        super.tearDown()
    }
        
    func testItemDetailModel() {
        viewModel?.deliveries = [getDummyItem()]
        let itemDetailVM = viewModel?.getDeliveryDetailViewModel(fromIndex: 0)
        XCTAssertNotNil(itemDetailVM?.item)
    }
    
    func testNilItemDetailModel() {
        viewModel?.deliveries = [getDummyItem()]
        let itemDetailVM = viewModel?.getDeliveryDetailViewModel(fromIndex: 1)
        XCTAssertNil(itemDetailVM?.item)
    }

}

// MARK: - Extension DeliveryItemViewModelTest
extension DeliveryItemViewModelTest {
    
    // MARK: - Get Dummy Item For Test
    func getDummyItem() -> DeliveryItem {
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        return DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
    }
}

// MARK: - MOCK API MANAGER
class MockAPIManager: APIManagerProtocol {
    
    var errorInResp = false
    
    // MARK: - API TO GET ITEM LIST FROM SERVER
    func getDeliveriesFromServer(offset: Int, limit: Int, completionBlock: @escaping APIManager.GetDeliveriesFromServerCompletion) {
        if errorInResp {
            let error = NSError(domain: "Error", code: 400, userInfo: nil)
            completionBlock(.failure(error))
            return
        } else {
            let deliveryItem = getDummyItem()
            completionBlock(.success([deliveryItem]))
        }
    }
    
    func getDummyItem() -> DeliveryItem {
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        return DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
    }
}

// MARK: - MOCK CORE DATA MANAGER
class MockCoreDataManager: CoredataManagerProtocol {
    
    static let mocksharedManager = MockCoreDataManager()
    var shouldReturnEmptyData: Bool!
    var shouldReturnErr: Bool!
    
    func fetchDeliveryItemFromLocalDB(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void)) {
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
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        let item = DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
        completion([item], nil)
    }
    
    func deleteDeliveryItemFromLocalDB(completion: @escaping ((Error?) -> Void)) {
        //mock delete
    }
    
    func saveDeliveryItemToLocalDB(items: [DeliveryItem]) {
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

