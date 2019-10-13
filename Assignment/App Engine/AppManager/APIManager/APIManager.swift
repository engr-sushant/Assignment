import Foundation
import Alamofire

typealias GetDeliveriesFromServerCompletion = ((Result<[DeliveryItem], Error>) -> Void)

class APIManager {
    
    // MARK: - BASEURL
    let BASEURL: String = "https://mock-api-mobile.dev.lalamove.com/"

    public enum apiName : String {
        
        case deliveries
        
        var description: String {
            switch self {
            case .deliveries     : return "deliveries"
            }
        }
    }
    
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
        
        let url = BASEURL + APIManager.apiName.deliveries.description
        let parameters: [String: Any] = [APIQueryConstants.keyOffset: offset, APIQueryConstants.keyLimit: limit]
        APIManager.apiService(url: url, parameter: parameters, completionHandler: completionBlock)
    }
}
