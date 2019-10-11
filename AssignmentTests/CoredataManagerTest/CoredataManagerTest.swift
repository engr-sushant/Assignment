import XCTest
import CoreData
@testable import Assignment

class CoredataManagerTest: XCTestCase {

    var coreDataManager: CoreDataManager?
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoredataConstants.stackName, managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-memory coordinator failed \(error)")
            }
        }
        return container
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        coreDataManager = CoreDataManager.shared
        coreDataManager?.persistentContainer = mockPersistantContainer
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataManager = nil
        super.tearDown()
    }
    
    func testSaveDeliveryItemToLocalDB() {
        guard let manager = self.coreDataManager else {
            XCTFail("coredatamanger is nil")
            return
        }
        _ = expectation(forNotification: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue), object: nil, handler: nil)
        let item = getDummyItem()
        manager.saveDeliveryItemToLocalDB(items: [item])
        //Assert save is called via notification (wait)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchDeliveryItemFromLocalDB() {
        guard let manager = self.coreDataManager else {
            XCTFail("coredatamanger is nil")
            return
        }
        let item = getDummyItem()
        manager.saveDeliveryItemToLocalDB(items: [item, item])
        let exp = expectation(description: "Test after a seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        guard result == XCTWaiter.Result.timedOut else {
            XCTFail("Delay interrupted")
            return
        }
        manager.fetchDeliveryItemFromLocalDB(offset: 0) { (items, err) in
            XCTAssertTrue(items.count == 2)
        }
    }
}

// MARK: - Extension AllItemViewModelTest
extension CoredataManagerTest {
    
    // MARK: - Get Dummy Item For Test
    func getDummyItem() -> DeliveryItem {
        let location = Location.init(latitude: 22.319181, longitude: 114.170008, address: "Mong Kok")
        return DeliveryItem.init(id: 38, itemDescription: "Deliver food to Eric", imageUrl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg", location: location)
    }
}

