import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared : CoreDataManager = {
        return CoreDataManager()
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let cont = NSPersistentContainer(name: CoredataConstants.stackName)
        cont.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        })
        return cont
    }()
    
    // MARK: - Convert Local DB Item Model Into Delivery Item model
    private func convertLocalDBItemModelIntoDeliveryItemModel(dbModel: EntityItem) -> DeliveryItem {
        let location = Location(latitude: dbModel.location?.latitude, longitude: dbModel.location?.longitude, address: dbModel.location?.address)
        let item = DeliveryItem.init(id: (Int(dbModel.id)), itemDescription: dbModel.itemDescription, imageUrl: dbModel.imageUrl ?? "", location: location)
        return item
    }
}

// MARK: - Extension CoreDataManger
extension CoreDataManager: CoredataManagerProtocol {
    
    // MARK: - Save Delivery Item To Local DB
    func saveDeliveryItemToLocalDB(items: [DeliveryItem]) {
        persistentContainer.performBackgroundTask { (context) in
            for item in items {
                let entityItem = EntityItem(context: context)
                entityItem.id = Int16(item.id)
                entityItem.itemDescription = item.description!
                entityItem.imageUrl = item.imageUrl
                let location = EntityLocation(context: context)
                if let lat = item.location?.lat, let lng = item.location?.lng, let address = item.location?.address {
                    location.latitude = lat
                    location.longitude = lng
                    location.address = address
                    entityItem.location = location
                }
            }
            do {
                try context.save()
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Delete Delivery Item From Local DB
    func deleteDeliveryItemFromLocalDB(completion: @escaping ((Error?) -> Void)) {
        let managedObjectContext = persistentContainer.newBackgroundContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataConstants.entityNameItem)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    // MARK: - Fetch Delivery Item From Local DB
    func fetchDeliveryItemFromLocalDB(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void)) {
        var items = [DeliveryItem]()
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoredataConstants.entityNameItem)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = fetchLimit
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard result as? [EntityItem] != nil else {
                completion(items, nil)
                return
            }
            items = result.map { self.convertLocalDBItemModelIntoDeliveryItemModel(dbModel: $0 as! EntityItem) }
            completion(items, nil)
        } catch let error as NSError {
            completion(items, error)
        }
    }
}
