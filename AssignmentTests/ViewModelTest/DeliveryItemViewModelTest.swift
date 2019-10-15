import XCTest
import CoreData
@testable import Assignment

class DeliveryItemViewModelTest: XCTestCase {

    // MARK: - VARIABLES
    var viewModel: DeliveryItemViewModel?
    var mockapimanager: MockAPIManager!
    var mockcoredatamanager = MockCoreDataManager.mocksharedManager
    var mockReachability: MockReachability!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        viewModel = DeliveryItemViewModel()
        
        viewModel?.coreDataManager = mockcoredatamanager
        mockcoredatamanager.shouldReturnErr = false
        mockcoredatamanager.shouldReturnEmptyData = false
        
        mockapimanager = MockAPIManager()
        viewModel?.apiManager = mockapimanager
        
        mockReachability = MockReachability()
        viewModel?.reachability = mockReachability
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockapimanager = nil
        mockReachability = nil
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
    
    func testLoadDataFromServerWithSuccess() {
        if let viewModel = viewModel {
            mockcoredatamanager.shouldReturnEmptyData = true //to make sure we do not get data from database and we hit api to get data
            viewModel.isRequestInProgress = false
            viewModel.loadData(withLoader: .APICallingLoader)
            XCTAssertTrue(viewModel.deliveries.count == 1)
        }
    }
    
    func testRefreshWithSuccess() {
        if let viewModel = viewModel {
            let item = getDummyItem()
            viewModel.deliveries = [item, item] //on refresh array count will change
            mockcoredatamanager.shouldReturnEmptyData = true
            viewModel.refreshData(withLoader: .APICallingLoader)
            XCTAssertTrue(viewModel.deliveries.count == 1)
        }
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
    func getDeliveriesFromServer(offset: Int, limit: Int, completionBlock: @escaping GetDeliveriesFromServerCompletion) {
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
    
    func fetchDeliveryItemsFromLocalDB(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void)) {
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
    
    func deleteDeliveryItemsFromLocalDB(completion: @escaping ((Error?) -> Void)) {
        //mock delete
    }
    
    func saveDeliveryItemsToLocalDB(items: [DeliveryItem]) {
        //mock save
    }
}

// MARK: - MOCK CONECTIVITY
class MockReachability: ReachabilityProtocol {
    
    func isInternetConnected() -> Bool {
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

