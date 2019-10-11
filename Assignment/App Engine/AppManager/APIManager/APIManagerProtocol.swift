import Foundation

protocol APIManagerProtocol {

    typealias GetItemsFromServerCompletion = (_ items : [DeliveryItem]?,_ error: Error?) -> Void

    /*
    Use this method to fetch all delivery items from server.
    **/
    func getItemsFromServer(offset              : Int,
                            limit               : Int,
                            completionBlock     : @escaping GetItemsFromServerCompletion)
}

