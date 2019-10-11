import Foundation

protocol APIManagerProtocol {

    typealias GetDeliveriesFromServerCompletion = ((Result<[DeliveryItem], Error>) -> Void)

    /*
    Use this method to get deliveries from server.
    **/
    func getDeliveriesFromServer(offset: Int, limit: Int, completionBlock: @escaping GetDeliveriesFromServerCompletion)
}

