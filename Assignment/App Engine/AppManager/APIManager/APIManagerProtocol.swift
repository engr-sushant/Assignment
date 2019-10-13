import Foundation

protocol APIManagerProtocol {

    /*
    Use this method to get deliveries from server.
    **/
    func getDeliveriesFromServer(offset: Int, limit: Int, completionBlock: @escaping GetDeliveriesFromServerCompletion)
}

