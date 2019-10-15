import Foundation

protocol CoredataManagerProtocol {

    /*
     Use this method to save delivery items to local DB.
     **/
    func saveDeliveryItemsToLocalDB(items: [DeliveryItem])
    
    /*
     Use this method to delete delivery items from local DB.
     **/
    func deleteDeliveryItemsFromLocalDB(completion: @escaping ((Error?) -> Void))
    
    /*
     Use this method to fetch delivery items from local DB.
     **/
    func fetchDeliveryItemsFromLocalDB(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void))
}
