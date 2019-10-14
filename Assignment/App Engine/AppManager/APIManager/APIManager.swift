import Foundation
import Alamofire

class APIManager {
    
    // MARK: - Use this method to make api calls
    private class func apiService<T: Decodable>(url                 : String,
                                                parameter           : [String: Any],
                                                completionHandler   : @escaping ((Result<T, Error>) -> Void)) {
        
        AF.request(url, method: .get, parameters: parameter).responseDecodable(decoder: JSONDecoder()) { (response: DataResponse<T>)  in
            completionHandler(response.result)
        }
    }
}

// MARK: - Extension APIManagerProtocol
extension APIManager: APIManagerProtocol {
    
    //MARK: - Get Deliveries From Server
    func getDeliveriesFromServer(offset             : Int,
                                 limit              : Int,
                                 completionBlock    : @escaping GetDeliveriesFromServerCompletion) {
        
        let url = BASEURL + APIConstants.APIName.deliveries.description
        let parameters: [String: Any] = [keyOffset: offset, keyLimit: limit]
        APIManager.apiService(url: url, parameter: parameters, completionHandler: completionBlock)
    }
}
