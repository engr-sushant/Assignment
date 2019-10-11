import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared : CoreDataManager = {
        return CoreDataManager()
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let cont = NSPersistentContainer(name: StackName)
        cont.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        })
        return cont
    }()
    
    //MARK:- Process coredata model into Item model
    private func processCoredataModelIntoItem(_ dbModelArray: [EntityItem]) -> [DeliveryItem] {
        var items = [DeliveryItem]()
        for dbModel in dbModelArray {
            items.append(DeliveryItem.init(withDBModel: dbModel))
        }
        return items
    }
}

//MARK: - Extension CoreDataManger
extension CoreDataManager: CoredataManagerProtocol {
    
    //MARK:- Save Item to Codedata
    func saveItemToLocalDB(items: [DeliveryItem]) {
        persistentContainer.performBackgroundTask { (context) in
            for item in items {
                let entityItemContext = EntityItem(context: context)
                entityItemContext.id = Int16(item.id!)
                entityItemContext.itemDescription = item.itemDescription!
                entityItemContext.imageUrl = item.imageUrl!
                let locationContext = EntityLocation(context: context)
                if let lat = item.location?.latitude, let lng = item.location?.longitude, let address = item.location?.address {
                    locationContext.latitude = lat
                    locationContext.longitude = lng
                    locationContext.address = address
                    entityItemContext.location = locationContext
                }
            }
            do {
                try context.save()
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    // MARK:- Delete Item from Coredata
    func deleteItemData(completion: @escaping ((Error?) -> Void)) {
        let managedObjectContext = persistentContainer.newBackgroundContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNameItem)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    // MARK:- Fetch Item from Coredata
    func fetchItemFromDatabase(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void)) {
        let items = [DeliveryItem]()
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNameItem)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = FetchLimit
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let res = result as? [EntityItem] else {
                completion(items, nil)
                return
            }
            completion(processCoredataModelIntoItem(res), nil)
            
        } catch let error as NSError {
            completion(items, error)
        }
    }
}
