import Foundation

protocol CoredataManagerProtocol {

    /*
     Use this method to save delivery item to local DB.
     **/
    func saveDeliveryItemToLocalDB(items: [DeliveryItem])
    
    /*
     Use this method to delete delivery item from local DB.
     **/
    func deleteDeliveryItemFromLocalDB(completion: @escaping ((Error?) -> Void))
    
    /*
     Use this method to fetch delivery item from local DB.
     **/
    func fetchDeliveryItemFromLocalDB(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void))
}
