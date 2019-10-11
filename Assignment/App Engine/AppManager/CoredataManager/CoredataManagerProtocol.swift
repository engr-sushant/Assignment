import Foundation

protocol CoredataManagerProtocol {

    /*
     Use this method to save delivery item to codedata.
     **/
    func saveItemToLocalDB(items: [DeliveryItem])
    
    /*
     Use this method to delete all delivery items from coredata.
     **/
    func deleteItemData(completion: @escaping ((Error?) -> Void))
    
    /*
     Use this method to fetch delivery item from coredata.
     **/
    func fetchItemFromDatabase(offset: Int, completion: @escaping (([DeliveryItem], Error?) -> Void))
}
